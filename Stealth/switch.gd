extends Area2D

var player_in_prox:bool
	
func _on_body_entered(body):
	player_in_prox = true


func _on_body_exited(body):
	player_in_prox = false

func _on_player_interact():
	if player_in_prox:
		if get_parent().get_node("PointLight2D").visible:
			get_parent().get_node("PointLight2D").visible = false
			get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		else:
			get_parent().get_node("PointLight2D").visible = true
			get_parent().process_mode = Node.PROCESS_MODE_INHERIT
			
