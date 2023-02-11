extends TileMap
class_name Level

signal actor_spawned(actor, at_pos)
signal actor_despawned(actor)
signal actor_selected(actor)
signal actor_left_level(actor)

enum {
	STONE_TILE
	CIVIL_TILE,
	BARRIER_TILE
}

var current_actor: Node2D
var current_selected_actor: Node2D

onready var objects: YSort = $Objects
onready var shadow_map: ShadowMap = $ShadowMap
onready var current_camera: CameraNode = $CameraNode

export (bool) var can_generate: bool = true
export (bool) var can_spawn_current_actor: bool = true
export (Vector2) var ascend_point: Vector2
export (Vector2) var descend_point: Vector2


func center_by_cell(global_vec: Vector2) -> Vector2:
	return global_vec + cell_size / 2


func spawn_cell(node: Node2D, x: int, y: int) -> void:
	spawn_cellv(node, Vector2(x, y))


func spawn_cellv(node: Node2D, vec: Vector2) -> void:
	spawn(node, map_to_world(vec))


func spawn(node: Node2D, at_pos: Vector2) -> void:
	node.position = at_pos
	objects.add_child(node)
	emit_signal("actor_spawned", node, at_pos)


func spawn_current_actor(node: Node2D, at_pos: Vector2) -> void:
	current_actor = node
	spawn(current_actor, at_pos)
	current_camera.follow(current_actor)


func despawn(node: Node2D) -> void:
	if node == current_actor:
		current_actor = null
	objects.remove_child(node)
	emit_signal("actor_despawned", node)


func has_actor(node: Node2D) -> bool:
	return node in objects.get_children()


func update_bitmask_rect(rect: Rect2) -> void:
	update_bitmask_region(rect.position, rect.end)


func get_shadow_map_visibilty() -> bool:
	return shadow_map.visible


func set_shadow_map_visibility(value: bool) -> void:
	shadow_map.visible = value


func select(actor: Node2D) -> void:
	current_selected_actor = actor
	emit_signal("actor_selected", actor)


func unselect() -> void:
	current_selected_actor = null


func is_actor_selected(actor: Node2D) -> bool:
	return current_selected_actor == actor
