extends Node2D

var curr:Color = Color.YELLOW
var rad = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	#position+=Vector2(20*delta,20*delta)
	pass

func _draw():
	draw_circle(get_parent().get_parent().position,20.0,Color.YELLOW)
