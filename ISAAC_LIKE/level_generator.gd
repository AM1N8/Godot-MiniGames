extends Node2D

var rooms = []
var rooms_positions = []
var end_rooms = []

@export var number_of_rooms = 10
@export var number_of_treasure_rooms = 1

@export var start_room: PackedScene

@export var normal_rooms: Array[PackedScene]
@export var treasure_rooms: Array[PackedScene]
@export var boss_rooms: Array[PackedScene]


var room_size: Vector2 = Vector2(512, 288)

## ADJUST THE SIZE OF BORDERS IF YOU WANT TO

var borders := Rect2(1, 1, 20, 20)
var starting_room_pos

var num_of_rooms_lbl: Label

@onready var level = $Rooms

func _ready():
	number_of_rooms = GameManager.number_of_rooms
	call_deferred("generate_level")
	num_of_rooms_lbl = $CanvasLayer/Label
	#num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(number_of_rooms)
	starting_room_pos = borders.size / 2
	
	## FOR THE ROOM SIZE TO BE IDENTIFIED CORRECTLY, IT SHOULD BE PLACED IN THE IV QUADRANT OF THE COORDINATE PLANE
	
	if normal_rooms.size() != 0:
		var inst = normal_rooms[0].instantiate()
		for i in inst.get_children():
			if i is TileMap:
				room_size = i.get_used_rect().size * i.tile_set.tile_size
		inst.queue_free()
	else:
		printerr("NO NORMAL ROOMS FOUND")


func generate_level():
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	if number_of_rooms < 7:
		number_of_rooms = 10
		num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(number_of_rooms)
	
	number_of_rooms = randi_range(number_of_rooms / 1.1, number_of_rooms * 1.2)
	
	var min_num_of_dead_ends = ceil(number_of_rooms / 3.0) + 1
	
	if min_num_of_dead_ends > 15:
		min_num_of_dead_ends = 15
	
	
	
	while end_rooms.size() < min_num_of_dead_ends or end_rooms.has(starting_room_pos):
		print("NEW GENERATION ATTEMPT")
		rooms.clear()
		end_rooms.clear()
		var walker = Walker.new(borders.size / 2, borders)
		rooms = walker.walk(number_of_rooms)
		end_rooms = walker.get_end_rooms()
		walker.call_deferred("queue_free")
	
	
	
	
	rooms_positions = rooms.duplicate()
	
	if start_room != null:
		place_starting_room()
	else:
		printerr("NO STARTING ROOM FOUND")
	
	if boss_rooms.size() != 0:
		place_boss_room()
	else:
		printerr("NO BOSS ROOM FOUND")
	
	if treasure_rooms.size() != 0:
		for i in number_of_treasure_rooms:
			place_treasure_room()
	else:
		printerr("NO TREASURE ROOM FOUND")
	
	
	if normal_rooms.size() != 0:
		for location in rooms:
			var inst = normal_rooms.pick_random().instantiate()
			level.call_deferred("add_child", inst)
			inst.position = location * room_size
			create_doors(location, inst)
	else:
		printerr("NO NORMAL ROOMS FOUND")


func place_starting_room():
	var inst = start_room.instantiate()
	level.call_deferred("add_child", inst)
	
	## STARTING ROOM ALWAYS IN THE SAME POSITION
	
	#inst.position = starting_room_pos * room_size
	#rooms.erase(starting_room_pos)
	
	## STARTING ROOM IN DIFFERENT POSITION EVERY TIME
	
	starting_room_pos = rooms.pick_random()
	while end_rooms.has(starting_room_pos):
		starting_room_pos = rooms.pick_random()
	
	inst.position = starting_room_pos * room_size
	
	create_doors(starting_room_pos, inst)
	
	rooms.erase(starting_room_pos)

func place_boss_room():
	var boss_room_location = starting_room_pos
	for i in end_rooms:
		var distance_to_end_room = starting_room_pos.distance_to(i)
		var distance_to_boss_room = starting_room_pos.distance_to(boss_room_location)
		if distance_to_end_room > distance_to_boss_room:
			boss_room_location = i
	
	var inst = boss_rooms.pick_random().instantiate()
	level.call_deferred("add_child", inst)
	inst.position = boss_room_location * room_size
	
	create_doors(boss_room_location, inst)
	
	rooms.erase(boss_room_location)
	end_rooms.erase(boss_room_location)

func place_treasure_room():
	var treasure_room_location = end_rooms[randi_range(0, end_rooms.size() - 1)]
	
	var inst = treasure_rooms.pick_random().instantiate()
	level.call_deferred("add_child", inst)
	inst.position = treasure_room_location * room_size
	
	create_doors(treasure_room_location, inst)
	
	rooms.erase(treasure_room_location)
	end_rooms.erase(treasure_room_location)








func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()





## IF YOU WANT TO USE YOUR OWN TILE MAP, ADJUST SOURCE_ID AND ATLAS COORDINATES

func create_doors(room_location, inst):
	for i in inst.get_children():
		if i is TileMap:
			var tile_map = i
			if rooms_positions.has(room_location + Vector2.LEFT):
				tile_map.set_cell(0, Vector2(0, tile_map.get_used_rect().size.y / 2 ), 1, Vector2i(1, 2))
				tile_map.set_cell(0, Vector2(0, tile_map.get_used_rect().size.y / 2 -1 ), 1, Vector2i(1, 2))
			if rooms_positions.has(room_location + Vector2.RIGHT):
				tile_map.set_cell(0, Vector2(tile_map.get_used_rect().size.x - 1, tile_map.get_used_rect().size.y / 2), 1, Vector2i(1, 2))
				tile_map.set_cell(0, Vector2(tile_map.get_used_rect().size.x - 1, tile_map.get_used_rect().size.y / 2 -1), 1, Vector2i(1, 2))
			if rooms_positions.has(room_location + Vector2.UP):
				tile_map.set_cell(0, Vector2(tile_map.get_used_rect().size.x / 2, 0), 1, Vector2i(1, 2))
				tile_map.set_cell(0, Vector2(tile_map.get_used_rect().size.x / 2 -1, 0), 1, Vector2i(1, 2))
			if rooms_positions.has(room_location + Vector2.DOWN):
				tile_map.set_cell(0, Vector2(tile_map.get_used_rect().size.x / 2, tile_map.get_used_rect().size.y - 1), 1, Vector2i(1, 2))
				tile_map.set_cell(0, Vector2(tile_map.get_used_rect().size.x / 2 -1, tile_map.get_used_rect().size.y - 1), 1, Vector2i(1, 2))
