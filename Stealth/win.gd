extends Area2D

@onready var win_id = randi() % get_tree().get_nodes_in_group("enemies").size()
# Called when the node enters the scene tree for the first time.



func _on_area_entered(area):
	if win_id== area.id:
		print("you have won")
		get_tree().reload_current_scene()
