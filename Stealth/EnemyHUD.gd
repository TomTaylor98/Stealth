extends Node2D

func _process(delta):
	queue_redraw()
func _draw():
	
	draw_circle(get_parent().get_parent().position - Vector2(0,20),5.0,Color.YELLOW)
