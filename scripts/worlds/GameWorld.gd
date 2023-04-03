extends Node2D
class_name GameWorld

enum {
	ASCEND_MODE,
	DESCEND_MODE
}

signal switch_ended(mode)
signal switch_started(mode)
signal switch_failed(mode, message)
signal depth_changed(depth)

var current_depth: int = -1 setget _set_current_depth

var _locked: bool = false setget , is_locked


func _lock() -> void:
	_locked = true


func _unlock() -> void:
	_locked = false


func _emit_switch_end(mode: int) -> void:
	emit_signal("switch_ended", mode)


func _emit_switch_start(mode: int) -> void:
	emit_signal("switch_started", mode)


func _emit_switch_fail(mode: int, with_message: String) -> void:
	emit_signal("switch_failed", mode, with_message)


func _set_current_depth(value: int) -> void:
	if current_depth != value:
		emit_signal("depth_changed", value)
	current_depth = value


func is_locked() -> bool:
	return _locked


func is_visited(depth: int) -> bool:
	return false


func switch(mode: int) -> void:
	pass
