extends ChunkPainter
class_name TunnelPainter


func draw() -> void:
	var i: int
	var radius: Vector2
	while (i < 4):
		if chunk.has_neighbour(i):
			radius = chunk.get_rounded_radius()
			draw_linev(
				radius,
				radius + radius * chunk.directions[i],
				Level.CIVIL_TILE)
		i += 1
