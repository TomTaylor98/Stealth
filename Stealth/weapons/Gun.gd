extends Node2D

var shot_count = 10
var bullet_count = 4
var bullet_speed = 500.0

var bullets:Array
var is_shaking:bool
var player_pos = Vector2(400,400)



func _ready():
	for i in bullet_count:
		bullets.append(bullet.new())

class bullet:
	var direction:Vector2
	var position:Vector2
	var speed:float

func _process(delta):
	queue_redraw()
	for b in bullets:
		b.position += b.direction*b.speed*delta
		$bullet.position = b.position
		
	if is_shaking:
		pass
		

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and shot_count:
		shot_count-=1
		for b in bullets:
			b.position = player_pos
			b.speed = 1000+ randi()%200
			b.direction = player_pos.direction_to(get_local_mouse_position()).normalized().rotated(deg_to_rad((-20+randi()%40)))
		
		
func _draw():
	if shot_count:
		for i in range(shot_count):
			draw_circle(Vector2.ZERO + Vector2(30 + i*20,30),10,Color.RED)
		
		for b in bullets:
			draw_circle(b.position,5.0,Color.YELLOW)
		
	draw_rect(Rect2(player_pos.x,player_pos.y,50,50),Color.BLACK,true)


func _on_timer_timeout():
	is_shaking = false


func _on_bullet_area_entered(area):
	pass


func _on_bullet_body_entered(body):
	print("we hit something")
