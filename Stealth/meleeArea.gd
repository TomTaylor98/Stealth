extends Area2D

var hit_sound_magnitude

signal make_noise(pos,magnitude)

var t:float = 0

var hit_sound_enemy:AudioStream = load("res://soundEffects/536254__hoggington__metal-gauntlet-punch.ogg")
var hit_sound_wall:AudioStream = load("res://soundEffects/581568__ipellison__metal-bars_hit9.wav")

func _process(delta):
	position = Vector2.ZERO
	if t>=0:
		t-=delta
	else:
		t =0
		monitoring = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		t = 2.0
		monitoring = true
		position = get_parent().get_local_mouse_position().normalized()*15
#	

func _ready():
	for e in get_tree().get_nodes_in_group("enemies"):
		connect("make_noise",e._on_make_sound)				
				

func _on_body_entered(body):
	if body.get_class()=="TileMap":
		
		get_parent().make_sound.emit(get_parent().position,20)
		$AudioStreamPlayer2D.stream = hit_sound_wall
		$sparks.emitting = true
		$AudioStreamPlayer2D.play()
		
		
	elif body.get_class()=="CharacterBody2D":
		body.lives +=-1
		get_parent().make_sound.emit(get_parent().position,20)
		$AudioStreamPlayer2D.stream = hit_sound_enemy
		$sparks.emitting = true
		$AudioStreamPlayer2D.play()
