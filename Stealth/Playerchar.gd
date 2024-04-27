extends CharacterBody2D

const MAX_AMMO_COUNT:int = 5
const MAX_LIVES:int = 5
const size = Vector2(20,20)
const BASE_SPEED = 50
const DASH_SPEED = 400
var current_speed = BASE_SPEED
var lives = 2
var ammo_count:int = MAX_AMMO_COUNT
signal shake
signal make_sound(pos,mag)

var in_light:bool = false
var is_dashing:bool
var dash_dest:Vector2

var current_dir:Vector2 = Vector2.RIGHT
var dash_dir:Vector2
const DASH_DISTANCE:float = 100
signal interact
signal sig_pos(pos)


func _physics_process(delta):
	emit_signal("sig_pos",position)
#	if !is_dashing:
#		if !$lightChecker.get_overlapping_areas():
#			in_light = false
#		else:
#			in_light = true
		

	if Input.is_key_pressed(KEY_SHIFT):
		emit_signal("make_sound",position,100)
		current_speed = DASH_SPEED
	else:
		current_speed = BASE_SPEED
		
	if Input.is_action_just_pressed("dash") and !is_dashing and !in_light:
		dash_dir = get_local_mouse_position().normalized()
		dash_dest = position + dash_dir*DASH_DISTANCE
		is_dashing = true
		
	if is_dashing:
		#print(move_and_collide(dash_dest*DASH_SPEED,true))
		#if move_and_collide(DASH_SPEED*delta*dash_dir,te)
		if !test_move(transform,DASH_SPEED*delta*dash_dir):
			position = position.move_toward(dash_dest,DASH_SPEED*delta)
		else:
			is_dashing = false
			
		if position==dash_dest:
			is_dashing = false
	else:
		var direction = Input.get_vector("left", "right","up","down")
		if direction!=Vector2.ZERO:
			current_dir = direction
		if direction:
			velocity = direction * current_speed*delta
		else:
			velocity = velocity.move_toward(Vector2.ZERO,current_speed)
		
		move_and_collide(velocity)

	
func _input(event):
	
#	
	if event.is_action_pressed("interact"):
		emit_signal("interact")
		
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_mask == MOUSE_BUTTON_RIGHT:
			shoot()
	
	
func use_meelee(weapon):
	pass

enum weapon_types{
	DISRUPTOR,
	
}

var current_weapon = weapon_types.DISRUPTOR
	
func shoot():
	if ammo_count:
		var new = $disruptor.duplicate()
		new.direction = get_local_mouse_position().normalized()
		new.visible = true
		new.process_mode = Node.PROCESS_MODE_ALWAYS
		new.get_child(0).shape.radius = 10
		new.position = position
		ammo_count-=1
		get_parent().add_child(new)

func make_noise():
	pass

func _on_getting_hit_by_projectile():
	lives-=1
	#play damaged animation
	$Camera2D.live_num+=-1
	if lives<=0:
		process_mode = Node.PROCESS_MODE_DISABLED


func _ready():
	for e in get_tree().get_nodes_in_group("enemies"):
		connect("make_sound",e._on_make_sound)
	for e in get_tree().get_nodes_in_group("enemies"):
		connect("sig_pos",e._on_sig_pos)
	for e in get_tree().get_nodes_in_group("interactables"):
		connect("interact",e._on_player_interact)
	
	
	
func _draw():
	draw_rect(Rect2(Vector2.ZERO-size/2,size),Color.BLACK)


func _on_light_checker_area_entered(area):
	if !is_dashing:
		in_light = true
	
func _on_light_checker_area_exited(area):
	if !is_dashing:
		in_light =false	

