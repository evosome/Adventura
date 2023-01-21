extends Object
class_name Chunk

enum {
	NONE_TYPE = -1,
	BRIDGE_TYPE,
	COMMON_TYPE,
	ASCEND_TYPE,
	DESCEND_TYPE
}

enum {
	NONE_DIRECTION = -1,
	UP_DIRECTION,
	DOWN_DIRECTION,
	LEFT_DIRECTION,
	RIGHT_DIRECTION
}

enum {
	UNKNOWN_STATUS,
	NEARBY_STATUS,
	KNOWN_STATUS
}

const DEFAULT_SIZE = Vector2(7, 7)

const directions_inverted: Array = [
	DOWN_DIRECTION,
	UP_DIRECTION,
	RIGHT_DIRECTION,
	LEFT_DIRECTION,
	NONE_DIRECTION
]

const directions: Array = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.ZERO
]

var level: Level
var bounds: Rect2
var parent: Chunk
var is_busy: bool
var position: Vector2 setget set_position
var rectangle: Rect2
var neighbours: Array
var chunk_type: int = NONE_TYPE
var known_status: int = UNKNOWN_STATUS
var free_directions: Array
var connected_direction: int = NONE_DIRECTION


func _init(
	level: Level,
	chunk_type: int,
	size: Vector2 = DEFAULT_SIZE):

	self.level = level
	self.chunk_type = chunk_type
	self.bounds = Rect2(Vector2.ZERO, size)
	self.neighbours = [
		null,
		null,
		null, 
		null]
	self.free_directions = [
		UP_DIRECTION,
		DOWN_DIRECTION,
		LEFT_DIRECTION,
		RIGHT_DIRECTION]
	self.rectangle = Rect2(Vector2.ZERO, bounds.end * level.cell_size)


func is_direction_free(direction: int) -> bool:
	return direction in free_directions


# GETTERS


func get_radius() -> Vector2:
	return bounds.size / 2


func get_position() -> Vector2:
	return bounds.position


func get_end() -> Vector2:
	return bounds.end


func get_rect_radius() -> Vector2:
	return rectangle.size / 2


func get_rect_center() -> Vector2:
	return rectangle.get_center()


func get_rect_position() -> Vector2:
	return rectangle.position


func get_rect_end() -> Vector2:
	return rectangle.end


func get_neighbour(direction: int) -> Chunk:
	return neighbours[direction] if direction < neighbours.size() else null


func get_random_direction() -> int:
	return Random.choice(free_directions)


# SETTERS


func set_position(new_position: Vector2) -> void:
	bounds.position = level.world_to_map(new_position)
	rectangle.position = new_position


# STATIC


static func invert_direction(direction: int) -> int:
	return directions_inverted[direction] \
		if direction < directions_inverted.size() \
		else NONE_DIRECTION


# MISC


func has_neighbour(direction: int) -> bool:
	return neighbours[direction] != null


func count_neighbours() -> int:
	return neighbours.size() - neighbours.count(null)


func point_as_busy(direction: int) -> void:
	free_directions.erase(direction)


func add_neighbour(direction: int, chunk: Chunk) -> void:
	if direction != NONE_DIRECTION and direction < neighbours.size():
		neighbours[direction] = chunk
		point_as_busy(direction)


func collides_chunk(other: Chunk) -> bool:
	return rectangle.intersects(other.rectangle)


func connect_chunk(other: Chunk, direction: int) -> void:
	add_neighbour(direction, other)
	other.parent = self
	other.connected_direction = direction
	other.add_neighbour(invert_direction(direction), self)


func calculate_distance(to_chunk: Chunk) -> Vector2:
	return get_rect_radius() + to_chunk.get_rect_radius()


func calculate_place_pos(neighbour: Chunk) -> Vector2:
	return get_rect_center() - neighbour.get_rect_center()


func calculate_neighbour_pos(neighbour: Chunk, direction: int) -> Vector2:
	return \
		calculate_place_pos(neighbour) + directions[direction] * \
		calculate_distance(neighbour)


func place(neighbour: Chunk, direction: int) -> void:
	neighbour.set_position(calculate_neighbour_pos(neighbour, direction))


# TILE DRAWING


func fill_shadow(with_tile: int) -> void:
	TileMapDraw.fill_rect(level.shadow_map, bounds, with_tile)


func set_cell(x: int, y: int, tile: int) -> void:
	set_cellv(bounds.position + Vector2(x, y), tile)


func set_cellv(vec: Vector2, tile: int) -> void:
	vec += bounds.position
	if bounds.has_point(vec):
		level.set_cellv(vec, tile)


func fill(with_tile: int) -> void:
	TileMapDraw.fill_rect(level, bounds, with_tile)


func fill_rect(rect: Rect2, with_tile: int) -> void:
	rect.position += bounds.position
	if bounds.encloses(rect):
		TileMapDraw.fill_rect(level, rect, with_tile)


func draw_linev(start: Vector2, end: Vector2, with_tile: int) -> void:
	var end_pos = bounds.position + end
	var start_pos = bounds.position + start
	if bounds.has_point(start_pos) and bounds.has_point(end_pos):
		TileMapDraw.draw_tile_linev(level, start_pos, end_pos, with_tile)


func draw_line(x: int, y: int, x1: int, y1: int, with_tile: int) -> void:
	draw_linev(Vector2(x, y), Vector2(x1, y1), with_tile)
