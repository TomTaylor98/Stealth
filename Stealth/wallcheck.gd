extends RayCast2D

signal wallhit
	
var dis = 40
var is_suspicous:bool


func _process(delta):
	
	if get_collider():
		emit_signal("wallhit")
	
func _on_changed_direction(new_dir):
	target_position = new_dir*dis

func _on_enemy_tree_entered():
	connect("wallhit",get_parent()._on_wallhit)
	target_position = get_parent().walk_direction*dis


