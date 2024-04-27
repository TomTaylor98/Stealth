extends Timer




func _on_timeout():
	get_parent().process_mode = Node.PROCESS_MODE_INHERIT
