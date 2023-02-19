extends Object
class_name Chunk

signal known_status_changed(new_status)

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

# Chunk rectangle calculated in cell units
var bounds: Rect2

# Chunk rectangle calculated in world units (calculated, when the chunk was
# placed)
var global_bounds: Rect2

# Parent chunk
var parent: Chunk

var position: Vector2
var neighbours: Array
var chunk_type: int = NONE_TYPE
var known_status: int = UNKNOWN_STATUS
var free_directions: Array
var neighbours_count: int = 0
var connected_direction: int = NONE_DIRECTION


func _init(
	chunk_type: int,
	size: Vector2 = DEFAULT_SIZE):

	self.chunk_type = chunk_type
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
	set_size(size)


func _point_as_busy(direction: int) -> void:
	free_directions.erase(direction)


func _add_neighbour(direction: int, chunk: Chunk) -> void:
	if direction != NONE_DIRECTION and direction < neighbours.size():
		neighbours[direction] = chunk
		neighbours_count += 1
		_point_as_busy(direction)


func _calculate_distance(to_chunk: Chunk) -> Vector2:
	return get_radius() + to_chunk.get_radius()


func _calculate_place_pos(neighbour: Chunk) -> Vector2:
	var center = get_center()
	var neighbour_center = neighbour.get_center()
	return center - neighbour_center


func _calculate_neighbour_pos(neighbour: Chunk, direction: int) -> Vector2:
	var distance = _calculate_distance(neighbour)
	var place_pos = _calculate_place_pos(neighbour)
	var neighbour_pos = place_pos + directions[direction] * distance
	return neighbour_pos


static func invert_direction(direction: int) -> int:
	return directions_inverted[direction] \
		if direction < directions_inverted.size() \
		else NONE_DIRECTION


func is_busy() -> bool:
	return neighbours_count == 4


# Check whether the certain rectangle ecnloses chunk bounds
func is_enclosed_by(rect: Rect2) -> bool:
	return rect.encloses(bounds)


func is_direction_free(direction: int) -> bool:
	return direction in free_directions


# Get radius in cell units
func get_radius() -> Vector2:
	return bounds.size / 2


# Get center of the chunk (center of its bounds) in cell units
func get_center() -> Vector2:
	return bounds.get_center()


func get_rounded_center() -> Vector2:
	return get_center().floor()


# Get radius floored (rounded down toward negative infinity) radius
func get_rounded_radius() -> Vector2:
	return get_radius().floor()


# Get position in cell units (exactly, the start of the chunk bounds)
func get_position() -> Vector2:
	return bounds.position


# Get position of bottom right corner in cell units (exactly, the end of the
# chunk bounds)
func get_end() -> Vector2:
	return bounds.end


func get_global_radius() -> Vector2:
	return global_bounds.size / 2


func get_global_center() -> Vector2:
	return global_bounds.get_center()


func get_global_position() -> Vector2:
	return global_bounds.position


func get_global_end() -> Vector2:
	return global_bounds.end


func get_neighbour(direction: int) -> Chunk:
	return neighbours[direction] if direction < neighbours.size() else null


func get_random_direction() -> int:
	return Random.choice(free_directions)


func set_size(cell_size: Vector2) -> void:
	bounds.size = cell_size


func set_position(cell_position: Vector2) -> void:
	bounds.position = cell_position


func set_global_size(global_size: Vector2) -> void:
	global_bounds.size = global_size


func set_global_position(global_position: Vector2) -> void:
	global_bounds.position = global_position


func set_known_status(value: int) -> void:
	known_status = value
	emit_signal("known_status_changed", value)


# Check whether the chunk has the point in its bounds (`vec` is a 2D Vector,
# that components are coordinates in cell units)
func has_point(vec: Vector2) -> bool:
	return bounds.has_point(vec)


func has_neighbour(direction: int) -> bool:
	return neighbours[direction] != null


func count_neighbours() -> int:
	return neighbours.size() - neighbours.count(null)


func collides_chunk(other: Chunk) -> bool:
	return bounds.intersects(other.bounds)


func connect_chunk(other: Chunk, direction: int) -> void:
	_add_neighbour(direction, other)
	other.parent = self
	other.connected_direction = direction
	other._add_neighbour(invert_direction(direction), self)


func place(at_cell_pos: Vector2, cell_size: Vector2) -> void:
	set_position(at_cell_pos)
	set_global_size(bounds.size * cell_size)
	set_global_position(bounds.position * cell_size)


func place_neighbour(
	neighbour: Chunk,
	direction: int,
	cell_size: Vector2) -> void:

	var neighbour_pos = _calculate_neighbour_pos(neighbour, direction)
	neighbour.place(neighbour_pos, cell_size)
