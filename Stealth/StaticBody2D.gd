extends StaticBody2D

var direction:Vector2 = Vector2.ZERO

var speed:float = 500

signal hit_player

func _ready():
		connect("hit_player",get_tree().get_first_node_in_group("player")._on_getting_hit_by_projectile)
func _draw():
	draw_circle(Vector2.ZERO,5.0,Color.GREEN_YELLOW)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move_and_collide(direction*speed*delta):
		emit_signal("hit_player")
		queue_free()


