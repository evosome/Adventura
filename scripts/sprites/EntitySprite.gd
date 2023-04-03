extends ShaderedSprite
class_name EntitySprite

export (Color) var _outline_color: Color setget set_outline_color


func _ready():
	set_shader(Assets.ENTITY_SHADER)


func play_animation(name: String) -> void:
	if frames != null and frames.has_animation(name):
		play(name)


func set_outline_color(color: Color) -> void:
	set_shader_param("outline_color", color)
	_outline_color = color
