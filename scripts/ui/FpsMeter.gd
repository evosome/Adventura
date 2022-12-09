extends Control
class_name FpsMeter

onready var fps_update_timer: Timer = $FpsUpdateTimer
onready var fps_output_label: Label = $HBoxContainer/FpsOutputLabel


func __on_timeout():
	fps_output_label.text = String(Engine.get_frames_per_second())
