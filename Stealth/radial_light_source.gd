extends Area2D

@export var size:int
var is_active:bool
var is_broken:bool

func _ready():
	pass

func _process(delta):
	if get_overlapping_bodies():
		pass
