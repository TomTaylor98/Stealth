extends Area2D


var next_room:String = "res://rooms/room2.tscn"


signal transition_to_next_room(next_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(area):
	var next_r = load(next_room).instantiate()
	
	print(next_r)
	emit_signal("transition_to_next_room",next_r)

func _ready():
	var gm = get_tree().get_first_node_in_group("GameManager")
	
	connect("transition_to_next_room",gm._on_transition_to_next_room)
	
