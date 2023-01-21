extends Control
class_name MemoryUsage

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var static_usage_label: Label = \
	$HBoxContainer/VBoxContainer/StaticUsageValue

var _recent_usage_value: int = 0


func __on_timer_timeout():
	var usage_value: int = OS.get_static_memory_usage()
	if usage_value > _recent_usage_value:
		animation_player.play("MemoryUp")
	elif usage_value < _recent_usage_value:
		animation_player.play("MemoryDown")
	_recent_usage_value = usage_value
	static_usage_label.text = String(usage_value)
