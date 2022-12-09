extends ChunkPainter
class_name TunnelPainter


func draw(chunk: Chunk) -> void:
	var radius: Vector2
	for direction in Chunk.ChunkDirections.values():
		if direction != Chunk.ChunkDirections.NONE and chunk.neighbours[direction]:
			radius = chunk.get_radius().floor()
			chunk.draw_linev(
				radius,
				radius + radius * chunk.directions[direction],
				Level.LevelTiles.CIVIL)
