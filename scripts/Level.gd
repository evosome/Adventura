extends TileMap
class_name Level

enum LevelTiles {
	STONE
	CIVIL,
	STAIRS_UP,
	STAIRS_DOWN,
	BARRIER
}

var current_actor: Node2D

onready var objects: YSort = $Objects
onready var shadow_map: ShadowMap = $ShadowMap
onready var current_camera: LevelCamera = $LevelCamera

export (bool) var can_generate: bool = true
export (bool) var can_spawn_current_actor: bool = true
export (Vector2) var ascend_point: Vector2
export (Vector2) var descend_point: Vector2


func spawn(node: Node2D, at_pos: Vector2) -> void:
	node.position = at_pos
	objects.add_child(node)


func spawn_current_actor(node: Node2D, at_pos: Vector2) -> void:
	current_actor = node
	spawn(current_actor, at_pos)
	current_camera.follow(current_actor)


func despawn(node: Node2D) -> void:
	if node == current_actor:
		current_actor = null
	objects.remove_child(node)


func has_actor(node: Node2D) -> bool:
	return node in objects.get_children()


func update_bitmask_rect(rect: Rect2) -> void:
	update_bitmask_region(rect.position, rect.end)
