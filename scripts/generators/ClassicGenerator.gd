extends LevelGenerator
class_name ClassicGenerator

enum GenerationState {
	IDLE,
	PLACING,
	PRE_DRAWING,
	DRAWING,
	POST_DRAWING,
	STOPPED
}

var current_state: int = GenerationState.IDLE
var last_placed_chunk: Chunk
var placed_chunks_count: int = 0
var used_rect_expanded: Rect2

onready var chunks: Array = []
onready var chunks_wavefront: Array = []

export (int) var max_chunks: int = 9


func _generate(level: Level):

	match current_state:
		
		GenerationState.IDLE:
			current_state = GenerationState.PLACING
		
		GenerationState.PLACING:
			if placed_chunks_count <= max_chunks:
				var current_chunk = select_neighbour(level, last_placed_chunk)
				
				if _try_place_chunk(current_chunk, last_placed_chunk):
					if current_chunk.chunk_type != Chunk.ChunkTypes.BRIDGE:
						placed_chunks_count += 1
					chunks.append(current_chunk)
					chunks_wavefront.append(current_chunk)
				else:
					current_chunk.free()

				if last_placed_chunk and last_placed_chunk.is_busy():
					chunks_wavefront.erase(last_placed_chunk)
				
				last_placed_chunk = Random.choice(chunks_wavefront)
			else:
				used_rect_expanded = _calculate_used_rect_expanded()
				current_state = GenerationState.PRE_DRAWING
		
		GenerationState.PRE_DRAWING:
			TileMapDraw.fill_rect(
				level,
				used_rect_expanded,
				Level.LevelTiles.BARRIER)
			current_state = GenerationState.DRAWING
		
		GenerationState.DRAWING:
			if chunks.size() != 0:
				paint(level, chunks.pop_front())
			else:
				current_state = GenerationState.POST_DRAWING

		GenerationState.POST_DRAWING:
			level.update_bitmask_rect(level.get_used_rect())
			current_state = GenerationState.STOPPED

		GenerationState.STOPPED:
			return GenerationStatus.DONE
		
	return GenerationStatus.PROCESSING


func _chunk_collides_others(chunk: Chunk) -> bool:
	for other_chunk in chunks:
		if chunk.collides_chunk(other_chunk):
			return true
	return false


func _try_place_chunk(chunk: Chunk, previous_chunk: Chunk) -> bool:

	if previous_chunk == null:
		chunk.set_position(Vector2.ZERO)
		return true
	
	var direction = previous_chunk.get_random_direction()
	
	previous_chunk.place(chunk, direction)
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


func select_painter(for_chunk: Chunk) -> ChunkPainter:
	var painter: ChunkPainter
	
	match for_chunk.chunk_type:
		Chunk.ChunkTypes.ASCEND:
			painter = AscendPainter.new()
		Chunk.ChunkTypes.DESCEND:
			painter = DescendPainter.new()
		Chunk.ChunkTypes.BRIDGE:
			painter = TunnelPainter.new()
		_:
			painter = CommonPainter.new()
	
	return painter


# Select neighbour chunk for the given one
func select_neighbour(level: Level, for_chunk: Chunk) -> Chunk:
	var chunk_type: int = \
		for_chunk.chunk_type if for_chunk else Chunk.ChunkTypes.NONE
	var next_chunk_type: int

	match chunk_type:
		Chunk.ChunkTypes.COMMON, \
		Chunk.ChunkTypes.ASCEND:
			next_chunk_type = Chunk.ChunkTypes.BRIDGE
		_:
			if placed_chunks_count >= max_chunks:
				next_chunk_type = Chunk.ChunkTypes.DESCEND
			elif placed_chunks_count == 0:
				next_chunk_type = Chunk.ChunkTypes.ASCEND
			else:
				next_chunk_type = Chunk.ChunkTypes.COMMON
	
	return Chunk.new(level, next_chunk_type)


func paint(level: Level, chunk: Chunk) -> void:
	var painter = select_painter(chunk)
	if painter:
		painter.draw(chunk)
	level.spawn(ChunkCollider.create_for(level, chunk), chunk.get_rect_center())
