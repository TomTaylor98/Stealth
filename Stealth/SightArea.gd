extends Area2D

const FLASHLIGHT_FOV = 45
const BASE_FOV = 50
const BASE_BEAM_DISTANCE = 200
const LIGHT_BEAM_DISTANCE = 100

var fov = BASE_FOV
var beam_direction:Vector2 = Vector2.RIGHT
var beam_distance:float = BASE_BEAM_DISTANCE

var is_flashlight_on:bool = false

var current_body:CharacterBody2D 

signal playerdetected(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_body = null
	is_flashlight_on = true
	beam_distance = BASE_BEAM_DISTANCE
	fov = BASE_FOV
	$CollisionShape2D.shape.radius = BASE_BEAM_DISTANCE
	$FlashLight.visible = is_flashlight_on
	connect("player_out_of_sight",get_parent()._on_player_out_of_sight)
	connect("playerdetected",get_parent()._on_player_detected)

var rotation_speed = 10.0

signal player_out_of_sight(pos)

var i:int = 0

func _physics_process(delta):
	
	
	queue_redraw()
	if current_body: #check if player is nearby
		$checkeyesight.target_position = to_local(get_overlapping_bodies()[0].position)
		$checkeyesight.force_raycast_update()
		#check if the body is in the field of view of the agent
		if beam_direction.angle_to(to_local(get_overlapping_bodies()[0].position))<deg_to_rad(fov) and beam_direction.angle_to(to_local(get_overlapping_bodies()[0].position))>-deg_to_rad(fov):
			if !$checkeyesight.get_collider() and current_body.position.distance_to(get_parent().position)<beam_distance: #check if there is a wall in the eyesight of the agent
				
				if get_overlapping_bodies()[0].in_light: #check is the player is visible
					emit_signal("playerdetected",get_overlapping_bodies()[0].position)
				else:
					if get_parent().is_flashlight_on:
						emit_signal("playerdetected",get_overlapping_bodies()[0].position)
						
#			else:
#				emit_signal("player_out_of_sight",position)
#		
	else: # if no bodies are near the agent then 
		$checkeyesight.target_position = Vector2.ZERO
		emit_signal("player_out_of_sight",position)




func _on_changed_direction(new_dir):
	beam_direction = new_dir
	#$FlashLight.rotate(beam_direction.angle_to(new_dir))
	$FlashLight.look_at(to_global(beam_direction))

			
func _draw():
	draw_line(Vector2.ZERO,beam_direction.rotated(deg_to_rad(fov))*beam_distance,Color.RED,1.0)
	draw_line(Vector2.ZERO,beam_direction.rotated(deg_to_rad(-fov))*beam_distance,Color.RED,1.0)
	draw_line(Vector2.ZERO,beam_direction*beam_distance,Color.RED)



func _on_lc_area_entered(area):
	await get_tree().create_timer(0.5).timeout
	is_flashlight_on = false
	beam_distance = BASE_BEAM_DISTANCE
	fov = BASE_FOV
	#$CollisionShape2D.shape.radius = BASE_BEAM_DISTANCE
	$FlashLight.visible = is_flashlight_on

func _on_lc_area_exited(area):
	await get_tree().create_timer(0.5).timeout	
	is_flashlight_on = true
	$FlashLight.visible = is_flashlight_on
	beam_distance = LIGHT_BEAM_DISTANCE
	#$CollisionShape2D.shape.radius = LIGHT_BEAM_DISTANCE
	fov = FLASHLIGHT_FOV



func _on_body_entered(body):
	i = 0
#	
	current_body = body


func _on_body_exited(body):
	i = 0
	current_body = null


func _on_light_checker_area_entered(area):
	await get_tree().create_timer(0.5).timeout
	is_flashlight_on = false
	beam_distance = BASE_BEAM_DISTANCE
	fov = BASE_FOV
	#$CollisionShape2D.shape.radius = BASE_BEAM_DISTANCE
	$FlashLight.visible = is_flashlight_on


func _on_light_checker_area_exited(area):
	await get_tree().create_timer(0.5).timeout	
	is_flashlight_on = true
	$FlashLight.visible = is_flashlight_on
	beam_distance = LIGHT_BEAM_DISTANCE
	#$CollisionShape2D.shape.radius = LIGHT_BEAM_DISTANCE
	fov = FLASHLIGHT_FOV
