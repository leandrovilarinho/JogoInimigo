extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var max_steps = 8
var min_size = 3
var max_size = 8
var tilemap:TileMap
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(_tilemap):
	tilemap = _tilemap
	
	var rect:Rect2i = tilemap.get_used_rect()
	position = Vector2(roundi(rect.size.x/2), roundi(rect.size.y/2))
	step_history.append(position)
	
	borders = Rect2(1, 1, rect.size.x-2, rect.size.y-2)

func walk(steps):
	place_room(position)
	for step in range(steps):
		if steps_since_turn >= max_steps:
			change_direction()
		
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	var size = Vector2(randi_range(min_size, max_size), randi_range(min_size, max_size))
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room







