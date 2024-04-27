extends PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var speed = 20
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed*delta
	
