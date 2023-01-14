extends Humanoid
class_name Player

signal ascend
signal descend

var current: bool = true


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	if current:
		self.level.spawn_current_actor(self, at_pos)
	else:
		self.level.spawn(self, at_pos)
