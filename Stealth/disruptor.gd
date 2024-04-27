extends Area2D

var direction:Vector2 = Vector2.ZERO
var speed:float = 3
var explosion_radius = 150
var is_copy:bool = false
var life_time = 0
signal hit_player
var rad = 5
signal hit_light_sig(pos,radius)

signal make_sound(pos,radius)

func _ready():
	for e in get_tree().get_nodes_in_group("enemies"):
		connect("make_sound",e._on_make_sound)
		
func _draw():
	draw_circle(Vector2.ZERO,rad,Color.GREEN_YELLOW)
	
func _physics_process(delta):
	position+=direction*speed
	if get_overlapping_bodies():
		
		$CollisionShape2D.shape.radius = explosion_radius
	
			
		for light in get_overlapping_areas():
			if light.position.distance_to(position)<explosion_radius:
				hit_light(light)
		emit_signal("make_sound",position,300)
		queue_free()
	
	
func hit_light(l:Area2D):
	connect("hit_light_sig",l._on_disruptor_hit_light)
	emit_signal("hit_light_sig",position,explosion_radius)
	disconnect("hit_light_sig",l._on_disruptor_hit_light)

func inc_rad():
	if rad<=100:
		rad+=5


func _on_body_entered(body):
	if body is CharacterBody2D:
		print("hit enemy")
		body.change_state(body.states.DISRUPTED)


func _on_body_exited(body):
	pass # Replace with function body.
