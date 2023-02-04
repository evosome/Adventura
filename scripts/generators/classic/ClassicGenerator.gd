extends Generator
class_name ClassicGenerator

enum GenerationState {
	IDLE,
	PLACING,
	PRE_DRAWING,
	DRAWING,
	POST_DRAWING,
	STOPPED
}

var chunks: Array
var chunks_wavefront: Array
var current_state: int
var last_placed_chunk: Chunk
var placed_chunks_count: int = 0
var used_rect_expanded: Rect2

export (int) var max_chunks: int = 9


func _on_end() -> void:
	chunks.clear()
	chunks_wavefront.clear()


func _on_start() -> void:
	chunks = []
	chunks_wavefront = []
	current_state = GenerationState.IDLE
	placed_chunks_count = 0


func _generate():

	match current_state:
		
		GenerationState.IDLE:
			current_state = GenerationState.PLACING
		
		GenerationState.PLACING:
			if placed_chunks_count <= max_chunks:
				var current_chunk = select_neighbour(level, last_placed_chunk)
				
				if current_chunk.chunk_type != Chunk.NONE_TYPE \
				and _try_place_chunk(current_chunk, last_placed_chunk):
					if current_chunk.chunk_type != Chunk.BRIDGE_TYPE:
						placed_chunks_count += 1
					chunks.append(current_chunk)
					if not current_chunk.is_busy():
						chunks_wavefront.append(current_chunk)
						
					last_placed_chunk = select_gen_chunk(
						last_placed_chunk, current_chunk)
					if last_placed_chunk and last_placed_chunk.is_busy():
						chunks_wavefront.erase(last_placed_chunk)
				else:
					current_chunk.free()
			else:
				used_rect_expanded = _calculate_used_rect_expanded()
				current_state = GenerationState.PRE_DRAWING
		
		GenerationState.PRE_DRAWING:
			TileMapDraw.fill_rect(
				level,
				used_rect_expanded,
				Level.BARRIER_TILE)
			current_state = GenerationState.DRAWING
		
		GenerationState.DRAWING:
			if chunks.size() != 0:
				paint(level, chunks.pop_front())
			else:
				current_state = GenerationState.POST_DRAWING

		GenerationState.POST_DRAWING:
			TileMapDraw.fill_rect(
				level.shadow_map,
				used_rect_expanded,
				ShadowMap.DARK_SHADOW)
			level.update_bitmask_rect(level.get_used_rect())
			current_state = GenerationState.STOPPED

		GenerationState.STOPPED:
			return DONE_STATUS
		
	return PROCESSING_STATUS


func _chunk_collides_others(chunk: Chunk) -> bool:
	for other_chunk in chunks:
		if chunk.collides_chunk(other_chunk):
			return true
	return false


func _try_place_chunk(chunk: Chunk, previous_chunk: Chunk) -> bool:

	if previous_chunk == null:
		chunk.place(Vector2.ZERO, level.cell_size)
		return true
	
	var direction = select_direction(chunk, previous_chunk)
	
	if direction == Chunk.NONE_DIRECTION:
		return false
	
	previous_chunk.place_neighbour(chunk, direction, level.cell_size)
	if not _chunk_collides_others(chunk):
		previous_chunk.connect_chunk(chunk, direction)
		return true

	return false


func _calculate_used_rect_expanded() -> Rect2:
	var rect: Rect2
	var rect_pos: Vector2
	var rect_end: Vector2
	var end_point: Vector2
	var start_point: Vector2
	for chunk in chunks:
		rect_end = chunk.get_end()
		rect_pos = chunk.get_position()
		if rect_pos.x < start_point.x:
			start_point.x = rect_pos.x
		if rect_pos.y < start_point.y:
			start_point.y = rect_pos.y
		if rect_end.x > end_point.x:
			end_point.x = rect_end.x
		if rect_end.y > end_point.y:
			end_point.y = rect_end.y
	rect.position = start_point - Vector2.ONE
	rect.end = end_point + Vector2.ONE
	return rect


func select_direction(for_chunk: Chunk, previous_chunk: Chunk) -> int:
	return Chunk.NONE_DIRECTION


func select_painter(for_chunk: Chunk) -> ChunkPainter:
	return null


func select_gen_chunk(current_chunk: Chunk, for_chunk: Chunk) -> Chunk:
	return null


func select_neighbour(level: Level, for_chunk: Chunk) -> Chunk:
	return null


func paint(level: Level, chunk: Chunk) -> void:
	var painter = select_painter(chunk)
	var chunk_center = chunk.get_global_center()
	var chunk_collider = ChunkCollider.create_for(chunk)
	var chunk_shadower = ChunkShadower.new(chunk, level)
	if painter:
		painter.level = level
		painter.chunk = chunk
		painter.draw()
	level.spawn(chunk_collider, chunk_center)
	level.spawn(chunk_shadower, chunk_center)
