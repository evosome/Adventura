extends Control
class_name Screen


signal change_requested(to_screen_name)


func switch_to(screen_name: String) -> void:
	emit_signal("change_requested", screen_name)
