extends LevelGenerator
class_name ClassicGenerator

enum GenerationState {
	IDLE,
	PLACING,
	DRAWING,
	STOPPED
}

var current_state: int = GenerationState.IDLE
var last_placed_chunk: Chunk
var placed_chunks_count: int = 0

onready var chunks: Array = []
onready var chunks_wavefront: Array = []

export (int) var max_chunks: int = 9


func _generate(level: Level):

	match current_state:
		
		GenerationState.IDLE:
			current_state = GenerationState.PLACING
		
		GenerationState.PLACING:
			if placed_chunks_count < max_chunks:
				var current_chunk = select_neighbour(level, last_placed_chunk)
				
				if try_place_chunk(level, current_chunk, last_placed_chunk):
					if current_chunk.chunk_type == Chunk.ChunkTypes.COMMON:
						placed_chunks_count += 1
					chunks.append(current_chunk)
					chunks_wavefront.append(current_chunk)
				else:
					current_chunk.free()

				if last_placed_chunk and last_placed_chunk.is_busy():
					chunks_wavefront.erase(last_placed_chunk)
				
				last_placed_chunk = Random.choice(chunks_wavefront)
			else:
				current_state = GenerationState.DRAWING
		
		GenerationState.DRAWING:
			if chunks.size() != 0:
				paint(level, chunks.pop_front())
			else:
				current_state = GenerationState.STOPPED

		GenerationState.STOPPED:
			level.update_bitmask_rect(level.get_used_rect())
			return GenerationStatus.DONE
		
	return GenerationStatus.PROCESSING


func chunk_collides_others(chunk: Chunk) -> bool:
	for other_chunk in chunks:
		if chunk.collides_chunk(other_chunk):
			return true
	return false


func try_place_chunk(
	on_level: Level,
	chunk: Chunk,
	previous_chunk: Chunk) -> bool:

	if not previous_chunk:
		chunk.set_position(Vector2.ZERO)
		return true
	
	var direction = previous_chunk.get_random_direction()
	
	previous_chunk.place(chunk, direction)
	if not chunk_collides_others(chunk):
		previous_chunk.connect_chunk(chunk, direction)
		return true

	return false


func select_painter(for_chunk: Chunk) -> ChunkPainter:
	if for_chunk.chunk_type == Chunk.ChunkTypes.BRIDGE:
		return TunnelPainter.new()
	else:
		return CommonPainter.new()


# Select neighbour chunk for the given one
func select_neighbour(level: Level, for_chunk: Chunk) -> Chunk:
	var chunk_type: int = \
		for_chunk.chunk_type if for_chunk else Chunk.ChunkTypes.NONE
	var next_chunk_type: int

	match chunk_type:
		Chunk.ChunkTypes.COMMON:
			next_chunk_type = Chunk.ChunkTypes.BRIDGE
		_:
			next_chunk_type = Chunk.ChunkTypes.COMMON
	
	return Chunk.new(level, next_chunk_type)


func paint(level: Level, chunk: Chunk) -> void:
	var painter = select_painter(chunk)
	if painter:
		painter.draw(chunk)
	level.spawn(ChunkCollider.create_for(level, chunk), chunk.get_rect_center())
