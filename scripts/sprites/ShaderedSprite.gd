extends AnimatedSprite
class_name ShaderedSprite

var _outline_material: ShaderMaterial

export (Shader) var _shader: Shader setget set_shader


func _init():
	_outline_material = ShaderMaterial.new()


func _ready():
	set_material(_outline_material)


func set_shader(shader: Shader) -> void:
	_outline_material.set_shader(shader)
	_shader = shader


func set_shader_param(param: String, value) -> void:
	_outline_material.set_shader_param(param, value)
