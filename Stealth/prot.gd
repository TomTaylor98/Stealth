extends Area2D


enum states{
	IDLE,
	ALERT
}

enum types{
	IDLE,
	PATROL
}

var current_state = states.IDLE
var current_type = types.IDLE

var fov = 30
var look_direction = Vector2.RIGHT
var look_distance = 100.0

func _ready():
	pass # Replace with function body.


func _process(delta):
	if current_type == types.IDLE:
		pass
		
	
func _draw():
	draw_circle(Vector2.ZERO,10.0,Color.RED)
	draw_line(Vector2.ZERO,look_direction.rotated(deg_to_rad(fov))*look_distance,Color.YELLOW,1.0)
	draw_line(Vector2.ZERO,look_direction.rotated(deg_to_rad(-fov))*look_distance,Color.YELLOW)
	draw_line(Vector2.ZERO,look_direction*look_distance,Color.YELLOW)
	
	
var tex = load("res://icon.svg")
