extends Area2D

var base_color:Color = Color.BLACK
var morph_color:Color
var morph_name:String 
var current_color = morph_color
var name_id:String = ""

var look_direction:Vector2
var walk_direction:Vector2
var speed = 50.0
var morph_id:int = 0 #zero means the player hasn't taken anything's shape
var id:int

var enemy_in_prox:bool = false

var a:Area2D

func _process(delta):
	queue_redraw()
	walk_direction = Input.get_vector("left","right","up","down")
	position += walk_direction*speed*delta
	look_direction = get_local_mouse_position().normalized()
	#look_at(get_global_mouse_position())
	if Input.is_key_pressed(KEY_SPACE):
		if $ProgressBar.value == 100:
			current_color = morph_color
			id = morph_id
			name_id = morph_name
		if enemy_in_prox and $ProgressBar.value!=100:
			look_at(a.position)
			$ProgressBar.visible = true
			$ProgressBar.value+=2
			$Camera2D.position = to_local(a.position)
			$Camera2D.zoom +=Vector2.ONE/10
			if $ProgressBar.value==100:
				morph_id = a.id
				name_id = a.name_id
				morph_color = a.current_color
				$Timer.start()
				$Camera2D.position = Vector2.ZERO
			$Label.text =str(id)
	else:
		$Camera2D.position = Vector2.ZERO
		$Camera2D.zoom = Vector2(4,4)
		$ProgressBar.visible = false
		
						
	if Input.is_key_pressed(KEY_CTRL):
		$Camera2D.zoom = Vector2(2,2)
		emit_signal("zoom_activate")
		speed = 50
	else:
		$Camera2D.zoom = Vector2(4,4)
		emit_signal("zoom_deactivate")
		speed = 100
	

signal zoom_activate
signal zoom_deactivate

func _draw():
	draw_circle(Vector2.ZERO,10.0,current_color)
	

func _input(event):
	if event.is_pressed() and event is InputEventMouse and event.button_mask==MOUSE_BUTTON_LEFT:
		pass
	
func _on_area_entered(area):
	enemy_in_prox = true
	a = area

func _on_area_exited(area):
	enemy_in_prox = false
	a = null

func _ready():
	$Label.text = str(morph_id)
	connect("zoom_activate",$Camera2D.on_zoom_activate)
	connect("zoom_deactivate",$Camera2D.on_zoom_deactivate)


func change_color(new_color:Color):
	current_color = new_color
func revert_to_base_color():
	current_color = morph_color
	

func _on_timer_timeout():
	morph_id = 0
	id = 0
	morph_color = base_color
	name_id = ""
	$ProgressBar.value = 0
