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


func update_bitmask_rect(rect: Rect2) -> void:
	update_bitmask_region(rect.position, rect.end)
