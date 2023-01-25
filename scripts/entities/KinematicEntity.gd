extends KinematicBody2D
class_name KinematicEntity

signal died
signal move_ended
signal move_started
signal cell_position_changed(from_pos, to_pos)

var level: Level
var cell_position: Vector2

onready var state_machine: StateMachine = $StateMachine

export (float) var speed: float = 50.0

var _previous_position: Vector2
var _previous_cell_position: Vector2


func _ready():
	_setup_state_machine()


func _physics_process(_delta):
	cell_position = level.world_to_map(position)

	if cell_position != _previous_cell_position:
		emit_signal(
			"cell_position_changed",
			_previous_cell_position,
			cell_position)

	if position != _previous_position and state_machine.current_state == "Idle":
		state_machine.transition_to("Moving")
		emit_signal("move_started")

	if position == _previous_position and state_machine.current_state == "Moving":
		state_machine.transition_to("Idle")
		emit_signal("move_ended")

	_previous_cell_position = cell_position
	_previous_position = position


func _setup_state_machine() -> void:
	state_machine.set_begin_state("Idle")
	state_machine.set_finite_state("Died")
	state_machine.add_transition("Idle", "Moving")
	state_machine.add_transition("Moving", "Idle")
	state_machine.add_transition("Idle", "Died")


func move(direction: Vector2) -> Vector2:
	return move_and_slide(direction * speed)


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	self.level.spawn(self, at_pos)


func despawn_from(level: Level) -> void:
	if level.has_actor(self):
		level.despawn(self)


func destroy() -> void:
	if level != null:
		despawn_from(level)
	queue_free()
