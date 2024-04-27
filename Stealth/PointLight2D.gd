extends PointLight2D


var flicker_timer:float
var is_on:bool
var is_jammed:bool
var is_broken:bool
var is_flickering:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_flickering:
		pass

func turn_off():
	visible = false
func turn_on():
	visible = true


func _on_light_checker_area_exited(area):
	pass
	#visible = true


func _on_light_checker_area_entered(area):
	pass
	visible = false
