extends TileMap


func InitNavmap():

	MAP_SIZE= get_used_rect().end
	var CELL_SIZE = tile_set.tile_size
	var offset = CELL_SIZE.x/2
	for i in range(MAP_SIZE.y):
		for j in range(MAP_SIZE.x):
			var new_id = i*MAP_SIZE.x+j
			var new_pos:Vector2 = Vector2(offset+ j*CELL_SIZE.x,offset+i*CELL_SIZE.y)
			nav_grid.add_point(new_id,new_pos)
			if get_cell_tile_data(1,local_to_map(new_pos)):
				nav_grid.set_point_disabled(new_id,true)
			
			var left_neighbour_id = new_id-1
#			var upper_left_neighbour_id = new_id-(MAP_SIZE.x-1)
			var upper_neighbour_id = new_id-(MAP_SIZE.x)
			if left_neighbour_id>=0:
				nav_grid.connect_points(left_neighbour_id,new_id)
			if upper_neighbour_id>=0:
				nav_grid.connect_points(upper_neighbour_id,new_id)
#			if upper_left_neighbour_id>=0:
#				nav_grid.connect_points(upper_left_neighbour_id,new_id)
			
	nav_grid_ids = nav_grid.get_point_ids()



func find_path(from:Vector2,to:Vector2):

	var id1:int = 10000
	var id2:int = 10001
	var path:PackedVector2Array
	var closest_id:int
	closest_id = nav_grid.get_closest_point(from)
	nav_grid.add_point(id1,from)
	nav_grid.connect_points(id1,closest_id,true)
	closest_id = nav_grid.get_closest_point(to)
	nav_grid.add_point(id2,to)
	nav_grid.connect_points(id2,closest_id,true)
	path = nav_grid.get_point_path(id1,id2)
	nav_grid.remove_point(id1)
	nav_grid.remove_point(id2)
	
	return path

func get_random_point():
	return nav_grid.get_point_position(Array(nav_grid_ids).pick_random())

func find_random_path(from:Vector2):
	return find_path(from,get_random_point())

var MAP_SIZE:Vector2
var CELL_SIZE:Vector2
var nav_grid = AStar2D.new()
var nav_grid_ids = []
var nav_grid_size = nav_grid.get_point_count()

#func _draw():
#	for id in nav_grid_ids:
#		if !nav_grid.is_point_disabled(id):
#			draw_circle(nav_grid.get_point_position(id),2.0,Color.ALICE_BLUE)
		
func _input(event):
	pass
#	if event is InputEventMouseButton and event.is_pressed():
#		if event.button_mask == MOUSE_BUTTON_LEFT:
#			if get_cell_tile_data(1,local_to_map(get_local_mouse_position())):
#				print("there is a wall here at " + str(local_to_map(get_local_mouse_position())))
#		if event.button_mask == MOUSE_BUTTON_RIGHT:
#			erase_cell(1,local_to_map(get_local_mouse_position()))
		
func _ready():
	InitNavmap()
