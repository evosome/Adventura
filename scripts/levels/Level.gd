extends TileMap
class_name Level

enum {
	STONE_TILE
	CIVIL_TILE,
	BARRIER_TILE
}
var current_actor: Actor
var current_selected_actor: Actor

onready var objects: YSort = $Objects
onready var shadow_map: ShadowMap = $ShadowMap

export (bool) var can_generate: bool = true
export (bool) var can_spawn_current_actor: bool = true
export (Vector2) var ascend_point: Vector2
export (Vector2) var descend_point: Vector2

var _world: GameWorld setget set_game_world

onready var _world2d: World2D = get_world_2d()
onready var _physics_state: Physics2DDirectSpaceState = \
	_world2d.direct_space_state


func get_proportional_cell_size() -> float:
	return cell_size.x


func set_game_world(world: GameWorld) -> void:
	_world = world


func center_by_cell(global_vec: Vector2) -> Vector2:
	return global_vec + cell_size / 2


func spawn_cell(actor: Actor, x: int, y: int) -> void:
	spawn_cellv(actor, Vector2(x, y))


func spawn_cellv(actor: Actor, vec: Vector2) -> void:
	spawn(actor, map_to_world(vec))


func spawn(actor: Node2D, at_pos: Vector2) -> void:
	actor.position = at_pos
	objects.add_child(actor)


func spawn_current(actor: Actor, at_pos: Vector2) -> void:
	current_actor = actor
	actor.current = true
	spawn(current_actor, at_pos)


func despawn(actor: Actor) -> void:
	if actor == current_actor:
		current_actor = null
	objects.remove_child(actor)


func has_actor(actor: Actor) -> bool:
	return actor in objects.get_children()


func update_bitmask_rect(rect: Rect2) -> void:
	update_bitmask_region(rect.position, rect.end)


func get_shadow_map_visibilty() -> bool:
	return shadow_map.visible


func set_shadow_map_visibility(value: bool) -> void:
	shadow_map.visible = value


func select(actor: Actor) -> void: 
	if not current_actor:
		return
	
	if current_selected_actor and current_selected_actor != actor:
		current_actor.unselect(current_selected_actor)
	
	if current_actor.can_select(actor):
		current_selected_actor = actor
		current_actor.select(actor)
		current_selected_actor.on_selected(current_actor)
	else:
		if current_selected_actor:
			current_actor.unselect(current_selected_actor)


func unselect() -> void:
	if current_actor and current_selected_actor:
		current_actor.unselect(current_selected_actor)
	current_selected_actor = null


func ascend() -> void:
	_world.switch(GameWorld.ASCEND_MODE)


func descend() -> void:
	_world.switch(GameWorld.DESCEND_MODE)


func get_actor_at(point: Vector2) -> Actor:
	if _world2d and _physics_state:
		var collision_data: Array = _physics_state.intersect_point(point)
		if collision_data.size() > 0:
			return collision_data[0].collider as Actor
	return null
