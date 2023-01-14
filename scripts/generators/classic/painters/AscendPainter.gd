extends ChunkPainter
class_name AscendPainter


func draw(chunk: Chunk) -> void:
	chunk.level.ascend_point = chunk.get_rect_center()
	chunk.fill(Level.LevelTiles.CIVIL)
	chunk.set_cellv(chunk.get_radius().floor(), Level.LevelTiles.STAIRS_UP)
