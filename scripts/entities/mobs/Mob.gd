extends KinematicEntity
class_name Mob

signal died
signal move_ended
signal move_started
signal cell_position_changed(from_pos, to_pos)

export (float) var move_speed: float = 50.0

var _velocity: Vector2
var _last_collision: KinematicCollision2D
var _previous_position: Vector2
var _previous_cell_position: Vector2


func _physics_process(_delta):
	
	if _velocity != Vector2.ZERO:
		_velocity = move_and_slide(_velocity)

	_last_collision = get_last_slide_collision()
	if _last_collision != null and _last_collision.collider is KinematicEntity:
		collide(_last_collision.collider)
		_last_collision.collider.on_collided(self)
	
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


func setup_state_machine() -> void:
	state_machine.set_begin_state("Idle")
	state_machine.set_finite_state("Died")
	state_machine.add_transition("Idle", "Moving")
	state_machine.add_transition("Moving", "Idle")
	state_machine.add_transition("Idle", "Died")


func move(direction: Vector2) -> void:
	_velocity = direction * move_speed
