extends Node2D

@export var type = types.PATROL
@export var name_id:String
@export var color:Color
var current_color = color

var id:int =1
var speed:int = 20.0
var look_direction:Vector2 = Vector2.RIGHT
var walk_direction:Vector2 = Vector2.DOWN

var look_distance:int = 130
var fov:float = 50.0
var choice = [-1,1]

var relations:Dictionary = {}

@onready var player 
var player_pos
var angle_to_player

var awareness_indicator_colors:Dictionary = {
	awareness_levels.BASE : Color.GRAY,
	awareness_levels.ALERT : Color.YELLOW
}

var awareness_level:int = awareness_levels.BASE
var current_state:states

var paste_direction

var turn_dir = 1

signal player_detected(player_position:Vector2)

func _process(delta):
	$Label.text = name_id
	queue_redraw()
	player_pos = to_local(player.position)
	
	if type==types.IDLE:
		look_direction = look_direction.rotated(turn_dir*deg_to_rad(0.4))
		if rad_to_deg(look_direction.angle_to(Vector2.RIGHT))>50 or rad_to_deg(look_direction.angle_to(Vector2.RIGHT))<-50:
			turn_dir = -turn_dir
		angle_to_player = rad_to_deg(look_direction.angle_to(player_pos.normalized()))
		
		if angle_to_player>-fov and angle_to_player<fov and Vector2.ZERO.distance_to(player_pos)< look_distance:
			$wall_checker.target_position = player_pos
			if !$wall_checker.get_collider():
				if id==player.id or player.id==0:
					get_tree().call_group("enemies","set_awareness_level",awareness_levels.ALERT)
					get_tree().call_group("enemies","find_path_to_player",to_global(player_pos))
					awareness_level = awareness_levels.ALERT
		else:
			awareness_level = awareness_levels.BASE
			
		if awareness_level == awareness_levels.ALERT:
			look_direction = player_pos
		
	if type == types.PATROL:
		look_direction =walk_direction
		position += speed*walk_direction*delta
		
		$RayCast2D.target_position = walk_direction*20
		if $RayCast2D.get_collider():
			if $RayCast2D.get_collider().get_class()=="TileMap":
				walk_direction = walk_direction.rotated(deg_to_rad(choice.pick_random()*45))
		
		if awareness_level == awareness_levels.ALERT:
			if path_to_player:
				follow_path()
			#position = position.move_toward(player.position,10)
			if position.distance_to(player.position)<20:
				print("game over")
				get_tree().paused = true
				
				
	angle_to_player = rad_to_deg(look_direction.angle_to(player_pos.normalized()))
	
	if angle_to_player>-fov and angle_to_player<fov and Vector2.ZERO.distance_to(player_pos)< look_distance:
		$wall_checker.target_position = player_pos
		if !$wall_checker.get_collider():
			if id==player.id or player.id==0:
				awareness_level = awareness_levels.ALERT
	
	else:
		awareness_level = awareness_levels.BASE
	
	
	
func _draw():
	draw_circle(Vector2.ZERO,10.0,current_color)
	draw_circle(Vector2.ZERO+Vector2(0,-20),5.0,awareness_indicator_colors[awareness_level])
	draw_line(Vector2.ZERO,look_direction.rotated(deg_to_rad(fov))*look_distance,current_color,1.0)
	draw_line(Vector2.ZERO,look_direction.rotated(deg_to_rad(-fov))*look_distance,current_color)
	draw_line(Vector2.ZERO,look_direction*look_distance,current_color)
	
enum states{
	PATROL,
	SUSPICIOUS,
	ALERT
}


func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	
	$Label.text = str(id)



var path_iterator:int = 0

func follow_path():
	position = position.move_toward(path_to_player[path_iterator],0.5)
	if position == path_to_player[path_iterator]:
		if path_iterator!=path_to_player.size()-1:
			path_iterator+=1
		else:
			path_to_player.clear()
			

func change_color(new_color:Color):
	current_color = new_color
func revert_to_base_color():
	current_color = color

func set_awareness_level(level:awareness_levels):
	awareness_level = level

var path_to_player:PackedVector2Array

func find_path_to_player(player_pos):
	path_to_player = get_parent().get_parent().find_path(position,player_pos)
	
