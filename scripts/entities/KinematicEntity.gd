extends KinematicBody2D
class_name KinematicEntity

var level: Level
var cell_position: Vector2

onready var state_machine: StateMachine = StateMachine.new()


func _ready():
	setup_state_machine()


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	self.cell_position = self.level.world_to_map(at_pos)
	self.level.spawn(self, at_pos)


func despawn_from(level: Level) -> void:
	if level.has_actor(self):
		level.despawn(self)

	
func destroy() -> void:
	if level != null:
		despawn_from(level)
	queue_free()


func setup_state_machine() -> void:
	pass


func collide(entity: KinematicEntity) -> void:
	pass


func on_collided(by_entity: KinematicEntity) -> void:
	pass
