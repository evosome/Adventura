extends ChunkPainter
class_name AscendPainter


func draw() -> void:
	level.ascend_point = chunk.get_global_center()
	fill(Level.CIVIL_TILE)
	set_cellv(chunk.get_rounded_radius(), Level.STAIRS_UP_TILE)
