extends GPUParticles2D


func _on_light_disrupted(pos):
	position = pos
	emitting = true
