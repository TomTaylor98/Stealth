extends Area2D

const FLASHLIGHT_FOV = 45
const BASE_FOV = 80
const BASE_BEAM_DISTANCE = 100
const LIGHT_BEAM_DISTANCE = 100

var fov = BASE_FOV
var beam_direction:Vector2 = Vector2.RIGHT
var beam_distance:float = BASE_BEAM_DISTANCE

var is_flashlight_on:bool = false

var current_body:CharacterBody2D 

signal playerdetected(pos)
var path:PackedVector2Array
# Called when the node enters the scene tree for the first time.
func _ready():
	current_body = null
	is_flashlight_on = true
	beam_distance = BASE_BEAM_DISTANCE
	fov = BASE_FOV
	
	$PointLight2D.visible = is_flashlight_on
	path = $Path2D.curve.get_baked_points()
	
	for i in range(path.size()):
		path[i] = to_global(path[i])
		
	for e in get_tree().get_nodes_in_group("enemies"):
		connect("sound_alarm",e._on_sound_alarm)
		
	
var rotation_speed = 10.0
var current_state = 0

var i:int = 0

const ALARM_DISTANCE:float = 500

func _physics_process(delta):
	
	queue_redraw()
	if current_state ==0:
		follow_path(delta)
		if current_body: #check if there are any bodies nearby
				#check if the body is the field of view of the agent
#			if beam_direction.angle_to(to_local(get_overlapping_bodies()[0].position))<deg_to_rad(fov) and beam_direction.angle_to(to_local(get_overlapping_bodies()[0].position))>-deg_to_rad(fov):
			$checkeyesight.target_position = to_local(current_body.position)
			$checkeyesight.force_raycast_update()
			if !$checkeyesight.get_collider(): #check if there is a wall in the eyesight of the agent
				
						#print("see ya")
						#alarm_patrols(position)
				emit_signal("sound_alarm",position,ALARM_DISTANCE)
				current_state = 1
				$alarmTimeoutTimer.start()
		else:
			$checkeyesight.target_position = Vector2.ZERO
	if current_state==1:
		#play alarm sound
		#start shooting at player
		#return to 
		pass

signal sound_alarm(pos)

var speed = 20
var path_iterator = 0

func follow_path(delta):
	if path_iterator==path.size():
		path_iterator = 0
	position = position.move_toward(path[path_iterator],speed*delta)
	if position==path[path_iterator]:
		path_iterator +=1 
		


#func alarm_patrols(p):
#	if $AlarmDistance.get_overlapping_bodies():
#		for e in $AlarmDistance.get_overlapping_bodies():
#			connect("sound_alarm",e._on_sound_alarm)
#			emit_signal("sound_alarm",p)
#			disconnect("sound_alarm",e._on_sound_alarm)
	

func _draw():
#	draw_line(Vector2.ZERO,beam_direction.rotated(deg_to_rad(fov))*beam_distance,Color.RED,1.0)
#	draw_line(Vector2.ZERO,beam_direction.rotated(deg_to_rad(-fov))*beam_distance,Color.RED,1.0)
#	draw_line(Vector2.ZERO,beam_direction*beam_distance,Color.RED)
	pass

func _on_body_entered(body):
	i = 0
	current_body = body


func _on_body_exited(body):
	i = 0
	current_body = null

func _on_alarm_timeout_timer_timeout():
	current_state = 0
