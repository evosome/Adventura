extends KinematicBody2D
class_name Entity


var level: Level


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	self.level.spawn(self, at_pos)


func despawn_from(level: Level) -> void:
	if level.has_actor(self):
		level.despawn(self)
