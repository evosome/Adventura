extends ChunkPainter
class_name DescendPainter


func draw(chunk: Chunk) -> void:
	chunk.known_status = Chunk.ChunkKnownStatus.NEARBY
	chunk.fill(Level.LevelTiles.CIVIL)
	chunk.set_cellv(chunk.get_radius().floor(), Level.LevelTiles.STAIRS_DOWN)
