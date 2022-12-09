extends ChunkPainter
class_name CommonPainter


func draw(chunk: Chunk) -> void:
	chunk.fill(Level.LevelTiles.STONE)
