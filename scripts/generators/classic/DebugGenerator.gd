extends ClassicGenerator
class_name DebugGenerator


func select_gen_chunk(current_chunk: Chunk, for_chunk: Chunk) -> Chunk:
	return for_chunk


func select_direction(for_chunk: Chunk, previous_chunk: Chunk) -> int:
	match previous_chunk.chunk_type:
		Chunk.ASCEND_TYPE:
			return Chunk.LEFT_DIRECTION
		Chunk.COMMON_TYPE:
			return previous_chunk.connected_direction
	return Chunk.NONE_DIRECTION


func select_painter(for_chunk: Chunk) -> ChunkPainter:
	var painter: ChunkPainter
	
	match for_chunk.chunk_type:
		Chunk.ASCEND_TYPE:
			painter = AscendPainter.new()
		Chunk.DESCEND_TYPE:
			painter = DescendPainter.new()
		Chunk.BRIDGE_TYPE:
			painter = TunnelPainter.new()
		_:
			painter = CommonPainter.new()
	
	return painter


func select_neighbour(level: Level, for_chunk: Chunk) -> Chunk:
	var chunk: Chunk
	var chunk_type: int = \
		for_chunk.chunk_type if for_chunk else Chunk.NONE_TYPE
	var next_chunk_type: int

	match chunk_type:
		Chunk.NONE_TYPE:
			next_chunk_type = Chunk.ASCEND_TYPE
		Chunk.ASCEND_TYPE:
			next_chunk_type = Chunk.COMMON_TYPE
		Chunk.COMMON_TYPE:
			next_chunk_type = Chunk.COMMON_TYPE

	return Chunk.new(next_chunk_type)
