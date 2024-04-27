extends Area2D

var is_disrupted:bool
var is_broken:bool

signal disrupted(pos)

func _ready():
	connect("disrupted",get_parent().get_node("lightsparks")._on_light_disrupted)

func _physics_process(delta):
#	
	if is_broken:
		visible = false
		monitoring = false
	
func _on_disrupt_timer_timeout():
	$AnimationPlayer.play("flicker")
	

func _on_animation_player_animation_finished(anim_name):
	is_disrupted = false
	monitoring = true
	monitorable = true
	visible = true



func _on_disruptor_hit_light(explosion_position,radius):
	if explosion_position.distance_to(position)<radius:
		
		visible = false
		$disruptTimer.start()
		$AudioStreamPlayer2D.play()
		emit_signal("disrupted",position)
		process_mode =Node.PROCESS_MODE_DISABLED
	



