extends Node2D
class_name GameWorld

signal level_added(level)
signal ascend_failed()
signal level_changed(level)
signal depth_changed(depth)
signal generation_ended(depth, on_level, used_generator)
signal generation_started(depth, on_level, used_generator)

var last_depth: int = -1
var current_level: Level setget set_current_level
var current_depth: int = -1 setget set_current_depth

onready var levels_container: Node = $Levels


func get_levels() -> Array:
	return levels_container.get_children()


func get_level_camera() -> LevelCamera:
	return current_level.current_camera if current_level else null


func select_level(depth: int) -> Level:
	return Scenes.TEST_LEVEL.instance() as Level


func select_generator(depth: int) -> LevelGenerator:
	return Scenes.CLASSIC_GENERATOR.instance() as LevelGenerator


func set_current_depth(new_depth: int) -> void:
	if new_depth < 0:
		return
	if new_depth < levels_container.get_child_count():
		set_level_by_depth(new_depth)
	else:
		create_level_at(new_depth)
	current_depth = new_depth
	if current_depth > last_depth:
		last_depth = current_depth
	emit_signal("depth_changed", new_depth)


func ascend() -> void:
	if current_depth > 0:
		set_current_depth(current_depth - 1)
	else:
		emit_signal("ascend_failed")


func descend() -> void:
	set_current_depth(current_depth + 1)


func add_level(level: Level) -> void:
	if level.visible:
		level.set_visible(false)
	levels_container.add_child(level)
	emit_signal("level_added", level)


func set_current_level(level: Level) -> void:
	if current_level != level:
		level.visible = true
		if current_level:
			current_level.visible = false
		current_level = level
		emit_signal("level_changed", level)


func set_level_by_depth(depth: int) -> void:
	set_current_level(levels_container.get_child(depth))


func generate_level(depth: int, level: Level, generator: LevelGenerator) -> void:
	generator.start_generation_for(level)
	emit_signal("generation_started", depth, level, generator)
	yield(generator, "generation_ended")
	emit_signal("generation_ended", depth, level, generator)


func create_level_at(new_depth: int) -> void:
	var level = select_level(new_depth)
	var generator = select_generator(new_depth)
	if level:
		add_level(level)
		if generator and level.can_generate:
			add_child(generator)
			generate_level(new_depth, level, generator)
		set_current_level(level)
