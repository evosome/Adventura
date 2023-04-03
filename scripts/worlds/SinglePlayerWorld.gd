extends GameWorld
class_name SinglePlayerWorld

var current_level: Level
var current_roadmap: Roadmap
var current_generator: Generator

onready var levels: Dictionary = {}
onready var world2d: World2D = get_world_2d()
onready var physics_state: Physics2DDirectSpaceState = world2d.direct_space_state
onready var current_player_data: PlayerData = PlayerData.new()

onready var _world_camera: CameraNode = $CameraNode
onready var _level_container: SingleNodeContainer = $Levels
onready var _player_entity_ref: Entity


func _process(_delta):
	if current_generator != null and current_generator.is_generating:
		var result: int = current_generator._generate()
		if result == Generator.DONE_STATUS:
			current_generator.stop_generation()


func _physics_process(_delta):
	if not current_level:
		return

	var actor: Actor = current_level.get_actor_at(get_global_mouse_position())
	if actor:
		current_level.select(actor)
	else:
		current_level.unselect()


func _set_level(level: Level) -> void:
	_level_container.switch_node(level)
	current_level = level


func _add_level(level: Level, depth: int) -> void:
	level.set_game_world(self)
	levels[depth] = level


func _select_level(depth: int) -> Level:
	return levels[depth] \
		if is_visited(depth) \
		else current_roadmap.get_level(depth)


func _select_generator(depth: int) -> Generator:
	return current_roadmap.get_generator(depth)


func _select_depth(current_depth: int, mode: int) -> int:
	var next_depth: int = current_depth
	match mode:
		ASCEND_MODE:
			next_depth = current_depth - 1
		DESCEND_MODE:
			next_depth = current_depth + 1
	return next_depth


func _generate_level(
	level: Level,
	generator: Generator) -> void:

	current_generator = generator
	current_generator.start_generation_for(level)
	yield(current_generator, "generation_ended")
	current_generator = null


func _spawn_player(level: Level, level_switch_mode: int) -> void:
	var spawn_point: Vector2
	
	_player_entity_ref = Player.create_from_data(current_player_data)
	match level_switch_mode:
		ASCEND_MODE:
			spawn_point = level.descend_point
		DESCEND_MODE:
			spawn_point = level.ascend_point
	_player_entity_ref.current = true
	_player_entity_ref.spawn(level, spawn_point)
	_world_camera.follow(_player_entity_ref)


func _despawn_player(level: Level) -> void:
	_world_camera.unfollow_current()
	_player_entity_ref.destroy()


func is_visited(depth: int) -> bool:
	return levels.has(depth)


func switch(mode: int) -> void:
	
	_emit_switch_start(mode)
	
	if is_locked():
		_emit_switch_fail(mode, "Game world is locked")
		return

	if current_roadmap == null:
		_emit_switch_fail(mode, "Roadmap is missing")
		return

	var next_depth: int = _select_depth(current_depth, mode)
	
	if next_depth < 0:
		_emit_switch_fail(mode, "Can not ascend to negative depth")
		return
	
	var prev_level: Level = current_level
	var next_level: Level = _select_level(next_depth)
	var next_generator: Generator

	if next_level == null:
		_emit_switch_fail(mode, "Level not found")
		return

	_lock()

	_set_level(next_level)
	_set_current_depth(next_depth)

	if not is_visited(next_depth):
		_add_level(next_level, next_depth)
		
		next_generator = _select_generator(next_depth)
		if next_generator != null:
			if next_level.can_generate:
				yield(_generate_level(next_level, next_generator), "completed")
			next_generator.queue_free()

	if prev_level:
		_despawn_player(prev_level)
	if next_level.can_spawn_current_actor:
		_spawn_player(next_level, mode)

	_unlock()

	_emit_switch_end(mode)
