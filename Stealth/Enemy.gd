extends CharacterBody2D

const BASE_FOV = 60
const FLASHLIGHT_FOV = 45

var walk_direction:Vector2 = Vector2.RIGHT
var beam_distance:float = 100
var fov = BASE_FOV
var rotation_speed = 10.0
var walking_speed:float = 30
var running_speed:float = 50
var indicator_color = Color.ROYAL_BLUE
var is_flashlight_on:bool = true
var point_of_suspicion:Vector2
var in_light:bool
@onready var player:CharacterBody2D =get_tree().get_first_node_in_group("player")

var player_in_sight:bool

var hearing_distance = 500

@export var type = 1

var current_state:states
var current_path:PackedVector2Array

var current_speed:float

enum states{
	UNAWARE,
	SUSPICIOUS,
	ALERT,
	CLUELESS,
	DISRUPTED
	
}

var colors  ={
	states.UNAWARE : Color.ALICE_BLUE,
	states.SUSPICIOUS : Color.YELLOW,
	states.ALERT : Color.RED,
	states.CLUELESS:Color.BEIGE,
	states.DISRUPTED:Color.PINK
}

signal turn_on_light
signal turn_off_light

var lives:int = 3

var last_state:states

func _on_sig_pos(pos):
	if pos.distance_to(position)<300:
		pass

func _physics_process(delta):
	queue_redraw()
	if lives<=0:
		queue_free() #die

	if current_state == states.UNAWARE:
		if player_in_sight:
			change_state(states.ALERT)
		if type == 0:
			pass
		if type == 1:
			position+=walk_direction*walking_speed*delta
		
	if current_state == states.SUSPICIOUS:
		
		if player_in_sight:
			change_state(states.ALERT)
		
		if !current_path.is_empty():
			follow_path(delta*running_speed)
		else:
			if $SuspicionCountDownTimer.is_stopped():
				$SuspicionCountDownTimer.start()
			current_path = get_parent().find_random_path(position)
			change_state(states.CLUELESS)
	
	
	if current_state==states.ALERT:
		if player_in_sight:
			if can_shoot:
				shoot()
		else:
			if !current_path.is_empty():
				follow_path(delta*running_speed)
			else:
				$AlertCountDownTimer.start()
				change_state(states.CLUELESS)
			
	if current_state == states.CLUELESS:
		var cur:float
		cur =  rand_offset_angle_left
		head_turn_angle = move_toward(head_turn_angle,cur,0.2)
		if head_turn_angle==rand_offset_angle_left:
			cur = rand_offset_angle_right
		if head_turn_angle==rand_offset_angle_right:
			cur = rand_offset_angle_left
		print(head_turn_angle)
		change_direction(walk_direction.rotated(deg_to_rad(1)))
	if current_state == states.DISRUPTED:
		
		pass
		
var head_turn_angle:float
var temp:Vector2

signal walk_direction_changed(new_dir)

func turn_head():
	pass

func change_direction(new_dir):
	walk_direction = new_dir
	emit_signal("walk_direction_changed",walk_direction)
	
var can_shoot = true

func shoot():
	var pr = $projectile.duplicate()
	pr.visible = true
	pr.direction = to_local(player.position).normalized()
	add_child(pr)
	can_shoot = false
	$ShootTimer.start()

func follow_path(speed):
	position = position.move_toward(current_path[0],speed)
	if position==current_path[0]:
		current_path.remove_at(0)
		if current_path:
			change_direction(to_local(current_path[0]).normalized())

signal hear_sound(from)

func _on_make_sound(sus_pos,mag):
	if current_state == states.UNAWARE:
		if position.distance_to(sus_pos)<hearing_distance:
			change_state(states.SUSPICIOUS)
			emit_signal("hear_sound",to_local(sus_pos))
			current_path = get_parent().find_path(position,sus_pos)
			
	
func _on_wallhit():
	if current_state == states.UNAWARE:
		var choice = [-1,1]
		change_direction(walk_direction.rotated(choice.pick_random()*deg_to_rad(90)))
	

func _on_player_detected(pos):
	player_in_sight = true
	change_state(states.ALERT)


func _on_player_out_of_sight(pos):
	if player_in_sight:
		current_path = get_parent().find_path(position,player.position)
	player_in_sight = false
	

func _on_suspicion_timer_timeout():
	change_state(states.UNAWARE)

func _on_alert_count_down_timeout():
	change_state(states.SUSPICIOUS)

func _on_shoot_timer_timeout():
	can_shoot = true

var rand_offset_angle_left:float
var rand_offset_angle_right:float

func change_state(new_state):
	if new_state == states.UNAWARE:
		current_path.clear()
		
	if new_state == states.SUSPICIOUS:
		current_speed = running_speed
		
	if new_state == states.ALERT:
		pass
	if new_state ==states.CLUELESS:
		rand_offset_angle_left = [30,45,60].pick_random()
		rand_offset_angle_right = [-30,-45,-60].pick_random()
		temp = walk_direction
	if new_state ==states.DISRUPTED:
		last_state = current_state
		$DisruptedCountdownTimer.start()
		$AnimationPlayer.play("flicker")
		
	$StateIndicatorLight.color = colors[current_state]
	indicator_color = colors[current_state]
	current_state = new_state
	

func _ready():
	
	current_state = states.UNAWARE
	connect("walk_direction_changed",$wallcheck._on_changed_direction)
	connect("walk_direction_changed",$SightArea._on_changed_direction)
	

func _on_melee_area_body_entered(body):
	
	lives +=-1
	set_process(false)
	await get_tree().create_timer(1).timeout
	if lives==0:
		queue_free()


func _on_sound_alarm(pos,rad):
	if current_state!=states.ALERT or current_state!=states.SUSPICIOUS:
		if position.distance_to(pos)<rad:
			change_state(states.SUSPICIOUS)
			current_path = get_parent().find_path(position,pos)



func _on_light_checker_area_entered(area):
	
	is_flashlight_on = false
	
func _on_light_checker_area_exited(area):
	is_flashlight_on = true
	


func _on_disrupted_countdown_timer_timeout():
	change_state(last_state)
	$AnimationPlayer.stop()
