extends ChunkPainter
class_name DescendPainter


func draw() -> void:
	level.descend_point = chunk.get_global_center()
	spawn_cellv(Scenes.STAIRS_DOWN.instance(), chunk.get_center())
	fill(Level.CIVIL_TILE)
