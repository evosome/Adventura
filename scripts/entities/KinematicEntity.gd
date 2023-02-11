extends KinematicBody2D
class_name KinematicEntity

var level: Level
var cell_position: Vector2

onready var state_machine: StateMachine = StateMachine.new()
onready var mouse_detection_area: Area2D = $MouseDetectionArea


func _ready():
	setup_state_machine()
	mouse_detection_area.connect("mouse_exited", self, "__on_mouse_exited")
	mouse_detection_area.connect("mouse_entered", self, "__on_mouse_entered")


func __on_mouse_exited() -> void:
	if level.is_actor_selected(self):
		level.unselect()


func __on_mouse_entered() -> void:
	if not level.is_actor_selected(self):
		level.select(self)


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	self.cell_position = self.level.world_to_map(at_pos)
	self.level.spawn(self, level.center_by_cell(at_pos))


func despawn_from(level: Level) -> void:
	if level.has_actor(self):
		level.despawn(self)

	
func destroy() -> void:
	if level != null:
		despawn_from(level)
	queue_free()


func setup_state_machine() -> void:
	pass


func collide(with_entity: KinematicEntity) -> void:
	with_entity.on_collided(self)


func interact(with_entity: KinematicEntity) -> void:
	with_entity.on_interacted(self)


func on_collided(by_actor: Node2D) -> void:
	pass


func on_interacted(by_actor: Node2D) -> void:
	pass
