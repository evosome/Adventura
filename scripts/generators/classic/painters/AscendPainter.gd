extends ChunkPainter
class_name AscendPainter


func draw() -> void:
	level.ascend_point = chunk.get_global_center()
	spawn_cellv(Scenes.STAIRS_UP.instance(), chunk.get_center())
	fill(Level.CIVIL_TILE)
