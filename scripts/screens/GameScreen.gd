extends Screen
class_name GameScreen

var _velocity: Vector2 = Vector2.ZERO

onready var viewport: Viewport = $ViewportContainer/Viewport
onready var level_list: ItemList = $GameWorldInfo/VBoxContainer/LevelsInfo/LevelList
onready var game_world: GameWorld = $ViewportContainer/Viewport/GameWorld
onready var depth_label: Label = $GameWorldInfo/VBoxContainer/HBoxContainer/DepthLabel
onready var level_camera: LevelCamera
onready var current_actor: Node2D
onready var current_roadmap: Roadmap = Scenes.CLASSIC_ROADMAP.instance()


func _ready():
	game_world.current_roadmap = current_roadmap


func _input(event: InputEvent):
	if level_camera:
		if event.is_action_pressed("zoom_in"):
			level_camera.decrease_zoom()
		if event.is_action_pressed("zoom_out"):
			level_camera.increase_zoom()


func _process(delta):
	if current_actor and current_actor is Player and current_actor.is_inside_tree():
		_velocity = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		_velocity = current_actor.move_and_slide(_velocity * 2000 * delta)


func __on_item_selected(index: int):
	pass


func __on_ascend_pressed():
	game_world.ascend()


func __on_descend_pressed():
	game_world.descend()


func __on_depth_changed(depth: int):
	depth_label.text = String(depth + 1)


func __on_level_changed(_last_level, new_level: Level, _mode):
	level_camera = new_level.current_camera
	current_actor = new_level.current_actor


func __on_level_added(level: Level, _depth):
	level_list.add_item(level.name)


func __on_generation_started(depth: int, _on_level, _used_generator):
	level_list.set_item_custom_fg_color(depth, Color.red)


func __on_generation_ended(depth: int, _on_level, _used_generator):
	level_list.set_item_custom_fg_color(depth, Color.green)
