extends Control
class_name Screen


var _screen_changer: ScreenChanger


func switch(to_screen: String) -> void:
	_screen_changer.change_screen(to_screen)


func set_screen_changer(screen_changer: ScreenChanger) -> void:
	_screen_changer = screen_changer


func on_exit() -> void:
	yield()


func on_enter() -> void:
	yield()
