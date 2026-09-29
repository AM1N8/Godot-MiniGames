extends Node2D
var current_element:Vector2 = Vector2(1,1)
var brush_size = 2
@onready var tileset = $blocks 
var sand = Vector2i(1,1)
var water = Vector2i(2,1)
var rock = Vector2i(0,0)
var empty = Vector2i(-1,-1)

func _ready():
	print(empty)
	loop_cells()

func _process(delta):
	
	var pos = tileset.local_to_map(get_global_mouse_position())
	
	if Input.is_action_pressed("lmb"):
		for x in brush_size:
			for y in brush_size:
				tileset.set_cell(0,pos + Vector2i(-x,-y),0,current_element)
				tileset.set_cell(0,pos + Vector2i(-x,y),0,current_element)
				tileset.set_cell(0,pos + Vector2i(x,-y),0,current_element)
				tileset.set_cell(0,pos + Vector2i(x,y),0,current_element)
	if Input.is_action_pressed("rmb"):
		for x in brush_size:
			for y in brush_size:
				tileset.set_cell(0,pos + Vector2i(-x,-y),0,Vector2(-1,-1))
				tileset.set_cell(0,pos + Vector2i(-x,y),0,Vector2(-1,-1))
				tileset.set_cell(0,pos + Vector2i(x,-y),0,Vector2(-1,-1))
				tileset.set_cell(0,pos + Vector2i(x,y),0,Vector2(-1,-1))

func loop_cells():
	var cells = tileset.get_used_cells_by_id(0,0,Vector2(1,1))+tileset.get_used_cells_by_id(0,0,Vector2(1,0))+tileset.get_used_cells_by_id(0,0,Vector2(1,2)) +tileset.get_used_cells_by_id(0,0,Vector2(1,3))+ tileset.get_used_cells_by_id(0,0,Vector2(0,0)) + tileset.get_used_cells_by_id(0,0,Vector2(2,1))
	for cell in cells:
		var cellindex = tileset.get_cell_atlas_coords(0,Vector2(cell.x,cell.y))
		match cellindex:
			sand:
				var down = check_if_cell_empty(cell.x,cell.y+1) 
				var left= check_if_cell_empty(cell.x-1,cell.y) 
				var right = check_if_cell_empty(cell.x+1,cell.y) 
				var down_left = check_if_cell_empty(cell.x-1,cell.y+1) 
				var down_right = check_if_cell_empty(cell.x+1,cell.y+1) 
				
				if right && left:
					if randi() % 2 :
						left = false
						right = true
				
				if get_cell_type(cell.x,cell.y+1) == water: #down
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,water)
					tileset.set_cell(0,Vector2i(cell.x,cell.y+1),0,sand)
					
				elif down:
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,empty)
					tileset.set_cell(0,Vector2i(cell.x,cell.y+1),0,sand)
				
				elif left && down_left:
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,empty)
					tileset.set_cell(0,Vector2i(cell.x-1,cell.y+1),0,sand)
				elif right && down_right:
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,empty)
					tileset.set_cell(0,Vector2i(cell.x+1,cell.y+1),0,sand)
			
			water:
				var down = check_if_cell_empty(cell.x,cell.y+1)
				var left= check_if_cell_empty(cell.x-1,cell.y)
				var right = check_if_cell_empty(cell.x+1,cell.y)
				
				if right && left:
					if randi() % 2 :
						left = false
						right = true
				if down:
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,empty)
					tileset.set_cell(0,Vector2i(cell.x,cell.y+1),0,water)
				elif left :
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,empty)
					tileset.set_cell(0,Vector2i(cell.x-1,cell.y),0,water)
				elif right:
					tileset.set_cell(0,Vector2i(cell.x,cell.y),0,empty)
					tileset.set_cell(0,Vector2i(cell.x+1,cell.y),0,water)

func get_cell_type(x,y):
	return tileset.get_cell_atlas_coords(0,Vector2(x,y))

func _on_timer_timeout():
	loop_cells()
	
func check_if_cell_empty(x,y):
	if tileset.get_cell_atlas_coords(0,Vector2(x,y)) == empty && tileset.map_to_local(Vector2(x,y)).y < 1490 && tileset.map_to_local(Vector2(x,y)).x < 2000 && tileset.map_to_local(Vector2(x,y)).x > 0:
		return true
	else:
		return false
func check_if_cell_water(x,y):
	if tileset.get_cell_atlas_coords(0,Vector2(x,y)) == water :
		return true
	else:
		return false
func _input(event):
	if Input.is_action_just_pressed("1"):
		current_element = sand
		$elem.text = "SAND"
	if Input.is_action_just_pressed("2"):
		current_element = rock
		$elem.text = "ROCK"
	if Input.is_action_just_pressed("3"):
		current_element = water
		$elem.text = "WATER"
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_up"):
		if brush_size < 5:
			brush_size +=1
			$nbr.text = str(int(brush_size))
			
	if Input.is_action_just_pressed("ui_down"):
		if brush_size > 1:
			brush_size -=1
			$nbr.text = str(int(brush_size))
		
