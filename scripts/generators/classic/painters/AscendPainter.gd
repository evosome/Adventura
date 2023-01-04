extends ChunkPainter
class_name AscendPainter


func draw(chunk: Chunk) -> void:
	chunk.known_status = Chunk.ChunkKnownStatus.KNOWN
	chunk.fill(Level.LevelTiles.CIVIL)
	chunk.set_cellv(chunk.get_radius().floor(), Level.LevelTiles.STAIRS_UP)
