extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var prev
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_overlapping_areas():
		print("sdadasd")
		owner.is_flashlight_on = true
	else:
		owner.is_flashlight_on = false
