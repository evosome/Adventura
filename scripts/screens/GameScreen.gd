extends Screen
class_name GameScreen

onready var viewport: Viewport = $ViewportContainer/Viewport
onready var level_list: ItemList = $GameWorldInfo/VBoxContainer/LevelsInfo/LevelList
onready var game_world: GameWorld = $ViewportContainer/Viewport/GameWorld
onready var depth_label: Label = $GameWorldInfo/VBoxContainer/HBoxContainer/DepthLabel
onready var level_camera: LevelCamera


func _ready():
	depth_label.text = String(game_world.current_depth + 1)


func _input(event: InputEvent):
	if event.is_action_pressed("do_generate"):
		game_world.current_depth = game_world.last_depth + 1
		
	if level_camera:
		if event.is_action_pressed("zoom_in"):
			level_camera.decrease_zoom()
		if event.is_action_pressed("zoom_out"):
			level_camera.increase_zoom()


func __on_level_added(level):
	level_list.add_item(level.name)


func __on_item_selected(index: int):
	game_world.current_depth = index


func __on_generation_started(depth, on_level, used_generator):
	level_list.set_item_icon(depth, Assets.GENERATING_ICON0)


func __on_generation_ended(depth, on_level, used_generator):
	level_list.set_item_icon(depth, Assets.GENERATING_ICON1)


func __on_depth_changed(depth):
	level_list.select(depth)
	depth_label.text = String(depth + 1)


func __on_ascend_pressed():
	game_world.ascend()


func __on_descend_pressed():
	game_world.descend()


func __on_level_changed(prev_level, new_level):
	level_camera = new_level.current_camera
