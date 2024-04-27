extends PointLight2D

@export var light_radius:float = 200.0 #radius of light source in pixels
var beam_direction = Vector2.ONE
# Called when the node enters the scene tree for the first time.
func _ready():
	texture_scale = 512.0/light_radius
	

func _process(delta):
	beam_direction = beam_direction.rotated(20)
	look_at(beam_direction)



