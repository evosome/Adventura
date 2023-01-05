extends TileMap
class_name Level

enum LevelTiles {
	STONE
	CIVIL,
	STAIRS_UP,
	STAIRS_DOWN,
	BARRIER
}

enum LevelShadows {
	BRIGHT,
	HALF_BRIGHT,
	DARK
}

var current_actor: Node2D

onready var objects: YSort = $Objects
onready var shadow_map: TileMap = $ShadowMap
onready var current_camera: LevelCamera = $LevelCamera

export (bool) var can_generate: bool = true


func __on_visibility_changed():
	current_camera.current = visible


func spawn(node: Node2D, at_pos: Vector2) -> void:
	node.position = at_pos
	if objects:
		objects.add_child(node)


func spawn_current_actor(node: Node2D, at_pos: Vector2) -> void:
	current_actor = node
	spawn(current_actor, at_pos)


func despawn(node: Node2D) -> void:
	if node == current_actor:
		current_actor = null
	remove_child(node)


func has_actor(node: Node2D) -> bool:
	return node in objects.get_children()


func update_bitmask_rect(rect: Rect2) -> void:
	update_bitmask_region(rect.position, rect.end)
