extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var target_position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	direction = DIRECTIONS[randi() % 4]



func walk(steps):
	var step_count = 0
	while(step_count < steps - 1):
		
		var max_hallway_length = ceil(steps / 3.0)
		
		if max_hallway_length < 4:
			max_hallway_length = 4
		
		if steps_since_turn >= 2:
			change_direction()
		if step():
			if step_history.has(target_position) == true:
				position = target_position
				change_direction()
				continue
			var neighbours = ncount(target_position)
			if neighbours > 1:
				change_direction()
				continue
			
			if randf() < 0.5:
				change_direction()
				continue
			
			if get_hallway_length(target_position) > max_hallway_length:
				change_direction()
				continue
			
			
			position = target_position
			
			step_history.append(position)
			step_count += 1
		else:
			change_direction()
	
	return step_history

func step():
	target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		return true
	else:
		return false

func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()


func get_end_rooms():
	var end_rooms = []
	for step_position in step_history:
		if ncount(step_position) == 1:
			end_rooms.append(step_position)
	
	return end_rooms


func get_hallway_length(position):
	var longest_hallway = 0
	var hallway_length = 0
	
	var start_room = position
	
	hallway_length = check_hallway_length(position, Vector2.RIGHT)
	longest_hallway = check_longest_hallway(longest_hallway, hallway_length)
	hallway_length = check_hallway_length(position, Vector2.LEFT)
	longest_hallway = check_longest_hallway(longest_hallway, hallway_length)
	
	
	hallway_length = check_hallway_length(position, Vector2.UP)
	longest_hallway = check_longest_hallway(longest_hallway, hallway_length)
	hallway_length = check_hallway_length(position, Vector2.DOWN)
	longest_hallway = check_longest_hallway(longest_hallway, hallway_length)
	
	return longest_hallway


func check_hallway_length(start_room, hallway_direction):
	var hallway_length = 1
	while (step_history.has(start_room + hallway_direction)):
			start_room += hallway_direction
			hallway_length += 1
	return hallway_length


func check_longest_hallway(longest_hallway, current_hallway_length):
	if current_hallway_length > longest_hallway:
		return current_hallway_length
	else:
		return longest_hallway


func ncount(pos):
	return int(step_history.has(pos + Vector2.LEFT)) \
	+ int(step_history.has(pos + Vector2.UP)) \
	+ int(step_history.has(pos + Vector2.RIGHT)) \
	+ int(step_history.has(pos + Vector2.DOWN))
