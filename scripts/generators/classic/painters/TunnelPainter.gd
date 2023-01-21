extends ChunkPainter
class_name TunnelPainter


func draw(chunk: Chunk) -> void:
	var i: int
	var radius: Vector2
	while (i < 4):
		if chunk.has_neighbour(i):
			radius = chunk.get_radius().floor()
			chunk.draw_linev(
				radius,
				radius + radius * chunk.directions[i],
				Level.LevelTiles.CIVIL)
		i += 1
