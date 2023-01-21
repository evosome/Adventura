extends Node2D
class_name GameWorld

enum {
	ASCEND_LEVEL,
	DESCEND_LEVEL
}

signal locked()
signal unlocked()
signal level_added(level, depth)
signal depth_changed(depth)
signal level_changed(level)
signal ascend_failed()
signal roadmap_missing()
signal generation_ended(depth, on_level, used_generator)
signal generation_started(depth, on_level, used_generator)
signal level_change_ended(at_depth, level, mode)
signal level_change_started(at_depth, level, mode)
signal level_not_found_at(depth)

var is_busy: bool = false
var current_level: Level
var current_depth: int = -1 setget _set_current_depth
var current_roadmap: Roadmap
var current_generator: LevelGenerator

onready var levels: Dictionary = {}
onready var current_player_data: PlayerData = PlayerData.new()

var _player_entity_ref: Player

onready var _level_container: SingleNodeContainer = $Levels


func _process(_delta):
	if current_generator != null and current_generator.is_generating:
		var result: int = current_generator._generate()
		if result == LevelGenerator.DONE_STATUS:
			current_generator.stop_generation()


func _lock() -> void:
	is_busy = true
	emit_signal("locked")


func _unlock() -> void:
	is_busy = false
	emit_signal("unlocked")


func _set_level(level: Level) -> void:
	_level_container.switch_node(level)
	current_level = level
	emit_signal("level_changed", level)


func _set_current_depth(value: int) -> void:
	if current_depth != value:
		emit_signal("depth_changed", value)
	current_depth = value


func _add_level(level: Level, depth: int) -> void:
	levels[depth] = level
	emit_signal("level_added", level, depth)


func _select_level(depth: int) -> Level:
	return levels[depth] \
		if is_level_visited(depth) \
		else current_roadmap.get_level(depth)


func _generate_level(
	depth: int,
	level: Level,
	generator: LevelGenerator) -> void:

	current_generator = generator
	current_generator.start_generation_for(level)
	yield(current_generator, "generation_ended")
	current_generator = null
	generator.queue_free()


func _spawn_player(level: Level, level_switch_mode: int) -> void:
	var spawn_point: Vector2
	
	_player_entity_ref = Player.create_from_data(current_player_data)
	match level_switch_mode:
		ASCEND_LEVEL:
			spawn_point = level.descend_point
		DESCEND_LEVEL:
			spawn_point = level.ascend_point
	_player_entity_ref.spawn_on(level, spawn_point)


func _despawn_player(level: Level) -> void:
	_player_entity_ref.destroy()


func _switch_level_by_depth(depth: int, mode: int) -> void:
	var level: Level
	var generator: LevelGenerator

	if is_busy:
		return

	if current_roadmap == null:
		emit_signal("roadmap_missing")
		return
	
	level = _select_level(depth)
	if level == null:
		emit_signal("level_not_found_at", depth)
		return

	_lock()
	
	emit_signal("level_change_started", depth, level, mode)

	if current_level != null:
		_despawn_player(current_level)

	_set_level(level)
	if not is_level_visited(depth):
		_add_level(level, depth)

		if level.can_generate:
			generator = current_roadmap.get_generator(depth)
			if generator:
				emit_signal("generation_started", depth, level, generator)
				yield(_generate_level(depth, level, generator), "completed")
				emit_signal("generation_ended", depth, level, generator)

	if level.can_spawn_current_actor:
		_spawn_player(level, mode)

	_set_current_depth(depth)

	_unlock()

	emit_signal("level_change_ended", depth, level, mode)


func is_level_visited(depth: int) -> bool:
	return levels.has(depth)


func get_level(depth: int) -> Level:
	return levels.get(depth)


func ascend() -> void:
	var temp_depth = current_depth - 1
	if temp_depth >= 0:
		_switch_level_by_depth(temp_depth, ASCEND_LEVEL)
	else:
		emit_signal("ascend_failed")


func descend() -> void:
	_switch_level_by_depth(current_depth + 1, DESCEND_LEVEL)
