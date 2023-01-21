extends Node
class_name LevelGenerator

enum {
	PROCESSING_STATUS,
	DONE_STATUS
}

signal generation_ended
signal generation_started

var level: Level
var is_generating: bool


func _on_end() -> void:
	pass


func _on_start() -> void:
	pass


func _generate() -> int:
	return DONE_STATUS


func stop_generation() -> void:
	self.is_generating = false
	_on_end()
	emit_signal("generation_ended")


func start_generation_for(level: Level) -> void:
	self.level = level
	self.is_generating = true
	_on_start()
	emit_signal("generation_started")
