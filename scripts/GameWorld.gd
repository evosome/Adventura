extends Node2D
class_name GameWorld

enum LevelSwitchMode {
	ASCEND,
	DESCEND
}

signal level_added(level, depth)
signal depth_changed(depth)
signal level_changed(last_level, new_level, mode)
signal ascend_failed()
signal roadmap_missing()
signal generation_ended(depth, on_level, used_generator)
signal generation_started(depth, on_level, used_generator)
signal level_not_found_at(depth)

var current_level: Level
var current_depth: int = -1 setget _set_current_depth
var current_roadmap: Roadmap
var current_level_camera: LevelCamera setget , get_current_level_camera

onready var levels: Dictionary = {}
onready var current_player_info: PlayerInfo = PlayerInfo.new()
onready var current_player: Player = current_player_info.create_player()

onready var _levels_container: SingleNodeContainer = $Levels
onready var _generators_container: Node = $Generators


func _set_current_depth(value: int) -> void:
	if current_depth != value:
		emit_signal("depth_changed", value)
	current_depth = value


func _add_level(level: Level, depth: int) -> void:
	emit_signal("level_added", level, depth)
	levels[depth] = level


func _add_generator(generator: LevelGenerator) -> void:
	_generators_container.add_child(generator)


func _select_level(depth: int) -> Level:
	return levels[depth] \
		if is_level_visited(depth) \
		else current_roadmap.get_level(depth)


func _generate_level(
	depth: int,
	level: Level,
	generator: LevelGenerator) -> void:

	_add_generator(generator)
	generator.start_generation_for(level)
	emit_signal("generation_started", depth, level, generator)
	yield(generator, "generation_ended")
	emit_signal("generation_ended", depth, level, generator)
	generator.queue_free()


func _spawn_player(level: Level, level_switch_mode: int) -> void:
	var spawn_point: Vector2
	match level_switch_mode:
		LevelSwitchMode.ASCEND:
			spawn_point = level.descend_point
		LevelSwitchMode.DESCEND:
			spawn_point = level.ascend_point
	current_player.spawn_on(level, spawn_point)


func _despawn_player(level: Level) -> void:
	current_player.despawn_from(level)


func _transfer_player(from_level: Level, to_level: Level, mode: int) -> void:
	if from_level:
		_despawn_player(from_level)
	if to_level.can_spawn_current_actor:
		_spawn_player(to_level, mode)


func _set_level(level: Level) -> void:
	_levels_container.switch_node(level)


func _switch_level_by_depth(depth: int, mode: int) -> void:
	var level: Level
	var is_visited: bool
	var generator: LevelGenerator

	if not current_roadmap:
		emit_signal("roadmap_missing")
		return
	
	level = _select_level(depth)
	is_visited = is_level_visited(depth)
	if not level:
		emit_signal("level_not_found_at", depth)
		return

	_set_level(level)
	if level.can_generate and not is_visited:
		_add_level(level, depth)
		generator = current_roadmap.get_generator(depth)
		if generator:
			yield(_generate_level(depth, level, generator), "completed")

	_transfer_player(current_level, level, mode)
	emit_signal("level_changed", current_level, level, mode)
	current_level = level


func is_level_visited(depth: int) -> bool:
	return levels.has(depth)


func get_level(depth: int) -> Level:
	return levels.get(depth)


func get_current_level_camera() -> LevelCamera:
	return current_level.current_camera if current_level else null


func ascend() -> void:
	var temp_depth = current_depth - 1
	if temp_depth >= 0:
		self.current_depth = temp_depth
		_switch_level_by_depth(current_depth, LevelSwitchMode.ASCEND)
	else:
		emit_signal("ascend_failed")


func descend() -> void:
	self.current_depth += 1
	_switch_level_by_depth(current_depth, LevelSwitchMode.DESCEND)
