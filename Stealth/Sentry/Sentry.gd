extends CharacterBody2D


var health
var beam_direction:Vector2 = Vector2.ONE # starting direction is one
var beam_distance:float = 100
var fov = 45
var body_in_range:bool
var rotation_speed = 10.0
var indicator_color = Color.ROYAL_BLUE
@export var type = 0



func _physics_process(delta):
	queue_redraw()
	beam_direction = beam_direction.rotated(deg_to_rad(rotation_speed*delta))
	

func _draw():
	draw_circle(Vector2.ZERO,10.0,indicator_color)
	draw_circle(Vector2.ZERO+Vector2(0,-20),5.0,indicator_color)
	draw_line(Vector2.ZERO,beam_direction.rotated(deg_to_rad(fov))*beam_distance,indicator_color,1.0)
	draw_line(Vector2.ZERO,beam_direction.rotated(deg_to_rad(-fov))*beam_distance,indicator_color,1.0)
	draw_line(Vector2.ZERO,beam_direction*beam_distance,indicator_color)


