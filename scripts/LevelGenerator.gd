extends Node
class_name LevelGenerator

enum GenerationStatus {
	PROCESSING,
	DONE
}

signal generation_ended
signal generation_started

var level: Level
var is_generating: bool = false setget set_is_generating


func _generate(level: Level) -> int:
	return GenerationStatus.DONE


func _process(_delta):
	if is_generating:
		if _generate(level) != GenerationStatus.PROCESSING:
			self.is_generating = false


func set_is_generating(value: bool) -> void:
	if value:
		emit_signal("generation_started")
	else:
		emit_signal("generation_ended")
	is_generating = value


func start_generation_for(level: Level) -> void:
	if self.level != level:
		self.is_generating = true
	self.level = level
