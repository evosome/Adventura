# Minimalistic implementation of FSM
extends Object
class_name StateMachine

signal transition_failed(from_state, to_state)
signal transition_happened(from_state, to_state)

var finite_state: String
var current_state: String

var _transitions: Dictionary


func _init():
	_transitions = {}


func set_begin_state(state: String) -> void:
	if not current_state:
		current_state = state


func set_finite_state(state: String) -> void:
	finite_state = state


func add_transition(from_state: String, to_state: String) -> void:
	if from_state != finite_state and not from_state in _transitions:
		_transitions[from_state] = []
	_transitions[from_state].append(to_state)


func has_transition(state: String, to_state: String) -> bool:
	return state in _transitions and to_state in _transitions[state]


func transition_to(state: String) -> void:
	if current_state and has_transition(current_state, state):
		emit_signal("transition_happened", current_state, state)
		current_state = state
