extends Control
class_name MainScene

signal screen_changed(new_screen)

var current_screen: Screen setget set_current_screen
onready var _screens_container: Node = $Screens

export (String) var entry_screen: String


func _ready():
	set_screen_by_name(entry_screen)


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func __on_screen_change_requested(to_screen_name: String):
	set_screen_by_name(to_screen_name)


func get_screens() -> Array:
	return _screens_container.get_children()


func set_current_screen(screen: Screen) -> void:
	screen.visible = true
	if current_screen:
		current_screen.visible = false
	current_screen = screen
	emit_signal("screen_changed", screen)


func set_screen_by_name(screen_name: String) -> void:
	var screen = _screens_container.get_node_or_null(screen_name)
	if screen:
		set_current_screen(screen)
