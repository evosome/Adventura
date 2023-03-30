extends Object
class_name ChunkPainter

var level: Level
var chunk: Chunk


func draw() -> void:
	pass


func spawn_cell(entity: Entity, x: int, y: int) -> void:
	spawn_cellv(entity, Vector2(x, y))


func spawn_cellv(entity: Entity, vec: Vector2) -> void:
	entity.spawn(level, level.map_to_world(vec))


func set_cell(x: int, y: int, tile: int) -> void:
	set_cellv(Vector2(x, y), tile)


func set_cellv(vec: Vector2, tile: int) -> void:
	vec += chunk.get_position()
	if chunk.has_point(vec):
		level.set_cellv(vec, tile)


func fill(tile: int) -> void:
	TileMapDraw.fill_rect(level, chunk.bounds, tile)


func fill_rect(rect: Rect2, with_tile: int) -> void:
	var rect_to_fill = Rect2(rect.position + chunk.get_position(), rect.size)
	if chunk.is_enclosed_by(rect_to_fill):
		TileMapDraw.fill_rect(level, rect_to_fill, with_tile)


func draw_linev(start: Vector2, end: Vector2, with_tile: int) -> void:
	var end_pos = end + chunk.get_position()
	var start_pos = start + chunk.get_position()
	if chunk.has_point(start_pos) and chunk.has_point(end_pos):
		TileMapDraw.draw_tile_linev(level, start_pos, end_pos, with_tile)


func draw_line(x: int, y: int, x1: int, y1: int, with_tile: int) -> void:
	draw_linev(Vector2(x, y), Vector2(x1, y1), with_tile)
