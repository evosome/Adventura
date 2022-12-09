extends TileMap
class_name Level

enum LevelTiles {
	STONE
	CIVIL,
}

onready var current_camera: LevelCamera = $LevelCamera

export (bool) var can_generate: bool = true


func __on_visibility_changed():
	current_camera.current = visible


func spawn(node: Node2D, position: Vector2) -> void:
	node.position = position
	add_child(node)


func fill_region(x: int, y: int, w: int, h: int, with_tile: int) -> void:
	var yt = y
	while (x < w):
		while (y < h):
			set_cell(x, y, with_tile)
			y += 1
		x += 1
		y = yt


func fill_rect(rect: Rect2, with_tile: int) -> void:
	var p0 = rect.position
	var p1 = p0 + rect.size
	fill_region(
		p0.x, p0.y,
		p1.x, p1.y,
		with_tile)


func draw_tile_line(x: int, y: int, x1: int, y1: int, with_tile: int) -> void:
	var t: int
	var dx: int = x1 - x
	var dy: int = y1 - y
	var es: int
	var el: int
	var pdx: int
	var pdy: int
	var signx: int = 1 if dx > 0 else -1
	var signy: int = 1 if dy > 0 else -1
	var errorc: int
	dx = abs(dx)
	dy = abs(dy)
	signx = signx if signx != 0 else 0
	signy = signy if signy != 0 else 0
	if (dx > dy):
		pdy = 0
		pdx = signx
		es = dy
		el = dx
	else:
		pdx = 0
		pdy = signy
		es = dx
		el = dy
	errorc = el / 2

	set_cell(x, y, with_tile)
	while (t < el):
		errorc -= es
		if (errorc < 0):
			x += signx
			y += signy
			errorc += el
		else:
			x += pdx
			y += pdy
		set_cell(x, y, with_tile)
		t += 1


func draw_tile_linev(start: Vector2, end: Vector2, with_tile: int) -> void:
	draw_tile_line(start.x, start.y, end.x, end.y, with_tile)


func update_bitmask_rect(rect: Rect2) -> void:
	update_bitmask_region(rect.position, rect.end)
