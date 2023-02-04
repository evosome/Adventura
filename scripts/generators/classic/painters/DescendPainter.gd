extends ChunkPainter
class_name DescendPainter


func draw() -> void:
	level.descend_point = chunk.get_global_center()
	fill(Level.CIVIL_TILE)
	set_cellv(chunk.get_rounded_radius(), Level.STAIRS_DOWN_TILE)
