extends Node2D

var current_savefile:String
var current_room_name:String = "room1"

func _ready():
	print("the game has started")
func save_game(to:String):
	FileAccess.open(current_savefile,FileAccess.WRITE)
	
func load_game(from:String):
	pass
func reload_from_checkpoint(from:String):
	load_game(current_room_name)

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_R and event.is_pressed():
			get_tree().reload_current_scene()


func _on_transition_to_next_room(next_room):
	$room1.queue_free()
	current_room_name = next_room.get_name()
	print(current_room_name)
	add_child(next_room)
	


