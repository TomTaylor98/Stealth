extends Area2D

var entered:bool
var fov:float = 45
signal detectEntity(pos)

var current_body

func _physics_process(delta):
	
	if entered:
		var deg = rad_to_deg(get_parent().beam_direction.angle_to(to_local(get_overlapping_bodies()[0].position)))
		if deg>-fov and deg<fov:
			emit_signal("detectEntity",current_body.position)
			

func _on_body_entered(body):
	entered = true
	current_body = body


func _on_body_exited(body):
	entered = false

func _ready():
	connect("detectEntity",get_parent())
