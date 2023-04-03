extends ScreenChanger
class_name BaseScreenChanger


var current_screen: Screen

onready var _screens: Dictionary = {}


func get_screen(screen_name: String) -> Screen:
	return _screens.get(screen_name)


func register_screen(screen_name: String, screen: Screen) -> void:
	_screens[screen_name] = screen


func change_screen(screen_name: String) -> void:
	var screen = get_screen(screen_name)
	
	if not screen:
		return

	if current_screen:
		yield(current_screen.on_exit(), "completed")
		remove_child(current_screen)

	add_child(screen)
	current_screen = screen

	yield(screen.on_enter(), "completed")
