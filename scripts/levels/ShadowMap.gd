extends TileMap
class_name ShadowMap

enum {
	NO_SHADOW,
	SMALL_SHADOW,
	DARK_SHADOW
}


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("disable_shadow_map"):
		visible = !visible
