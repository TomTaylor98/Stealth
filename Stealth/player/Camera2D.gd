extends Camera2D

var listening_mode_active:bool = false

func _process(delta):
	queue_redraw()

func _draw():
	if listening_mode_active:
		draw_circle(Vector2.ZERO,30,Color.BLACK)
		draw_rect(Rect2(-get_viewport_rect().end.x/2,-get_viewport_rect().end.y/2,get_viewport_rect().end.x,get_viewport_rect().end.y),Color.BLACK)

func on_zoom_activate():
	listening_mode_active = true
	get_tree().call_group("entities","change_color",Color.WHITE)
	
	
func on_zoom_deactivate():
	listening_mode_active = false
	get_tree().call_group("entities","revert_to_base_color")
	

	
