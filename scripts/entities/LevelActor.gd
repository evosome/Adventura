extends Actor
class_name LevelActor

var level: Level


func spawn(level: Level, position: Vector2) -> void:
	self.level = level
	self.cell_position = self.level.world_to_map(position)
	if current:
		self.level.spawn_current(self, level.center_by_cell(position))
	else:
		self.level.spawn(self, level.center_by_cell(position))


func despawn() -> void:
	if level != null and level.has_actor(self):
		level.despawn(self)


func destroy() -> void:
	despawn()
	queue_free()
