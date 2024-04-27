extends Node2D



func _process(delta):
	queue_redraw()

var rad

func _draw():
	draw
	for i in owner.ammo_count:
		draw_circle(Vector2.ZERO +Vector2(40,50) + Vector2(50*i,0),7.0,Color.WHITE)
