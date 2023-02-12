extends Control
class_name MainScene

onready var _screens_changer: BaseScreenChanger = $BaseScreenChanger


func _ready():
	_screens_changer.register_screen("game_screen", Scenes.GAME_SCREEN.instance())
	_screens_changer.change_screen("game_screen")


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
