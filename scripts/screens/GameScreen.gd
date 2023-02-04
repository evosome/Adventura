extends Screen
class_name GameScreen

var level: Level
var level_camera: CameraNode

onready var viewport: Viewport = $ViewportContainer/Viewport
onready var level_list: ItemList = $GameWorldInfo/VBoxContainer/LevelsInfo/LevelList
onready var game_world: GameWorld = $ViewportContainer/Viewport/GameWorld
onready var depth_label: Label = $GameWorldInfo/VBoxContainer/HBoxContainer/DepthLabel
onready var current_roadmap: Roadmap = Scenes.DEBUG_ROADMAP.instance()


func _ready():
	game_world.current_roadmap = current_roadmap


func _input(event: InputEvent):
	if level_camera:
		if event.is_action_pressed("zoom_in"):
			level_camera.decrease_zoom()
		if event.is_action_pressed("zoom_out"):
			level_camera.increase_zoom()
	if level and event.is_action_pressed("disable_shadow_map"):
		level.set_shadow_map_visibility(!level.get_shadow_map_visibilty())


func __on_item_selected(index: int):
	pass


func __on_ascend_pressed():
	game_world.ascend()


func __on_descend_pressed():
	game_world.descend()


func __on_depth_changed(depth: int):
	depth_label.text = String(depth + 1)
	level_list.select(depth)


func __on_level_changed(level: Level):
	self.level = level
	self.level_camera = level.current_camera


func __on_level_added(level: Level, _depth):
	level_list.add_item(level.name)


func __on_generation_started(depth: int, _on_level, _used_generator):
	level_list.set_item_custom_fg_color(depth, Color.red)


func __on_generation_ended(depth: int, _on_level, _used_generator):
	level_list.set_item_custom_fg_color(depth, Color.green)
