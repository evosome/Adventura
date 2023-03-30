extends Entity
class_name Mob

signal died
signal move_ended
signal move_started
signal cell_position_changed(from_pos, to_pos)

export (float) var move_speed: float = 50.0
export (float) var acceleration: float = 0.3
export (float) var cell_interaction_range: float = 3.0

onready var attack_area: Area2D = $AttackArea

var _velocity: Vector2
var _last_collider: Object
var _last_collision: KinematicCollision2D
var _previous_position: Vector2
var _previous_cell_position: Vector2


func _input(event: InputEvent):
	
	if not current:
		return
	
	# These interactions are temporary and will be replaced by actions
	if event.is_action_pressed("attack"):
		attack(get_global_mouse_position())
	
	if event.is_action_pressed("interact"):
		var current_selected = level.current_selected_actor
		if current_selected and can_interact(current_selected):
			interact(level.current_selected_actor)


func _physics_process(_delta):
	
	if current:
		var _xvelocity = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		move(_xvelocity)
	
	if _velocity != Vector2.ZERO:
		_velocity = move_and_slide(_velocity)

	_last_collision = get_last_slide_collision()
	if _last_collision != null:
		var collider = _last_collision.collider
		if collider is Entity and _last_collider != collider:
			collide(collider)
		_last_collider = collider
	else:
		_last_collider = null
	
	cell_position = level.world_to_map(position)

	if cell_position != _previous_cell_position:
		emit_signal(
			"cell_position_changed",
			_previous_cell_position,
			cell_position)

	if position != _previous_position and state_machine.current_state == "Idle":
		state_machine.transition_to("Moving")
		play_animation("Moving")
		emit_signal("move_started")

	if position == _previous_position and state_machine.current_state == "Moving":
		state_machine.transition_to("Idle")
		play_animation("Idle")
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
	_velocity = lerp(_velocity, direction * move_speed, acceleration)


func attack(point: Vector2) -> void:
	attack_area.look_at(point)
	for actor in attack_area.get_overlapping_bodies():
		if actor is Actor or actor != self:
			hit(actor)


func can_select(actor: Actor) -> bool:
	return get_actor_cell_distance(actor) < cell_interaction_range


func can_interact(actor: Actor) -> bool:
	return get_actor_cell_distance(actor) < cell_interaction_range
