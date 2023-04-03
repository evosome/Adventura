extends Screen
class_name GameScreen

var level: Level
var level_camera: CameraNode

onready var viewport: Viewport = $ViewportContainer/Viewport
onready var game_world: GameWorld = $ViewportContainer/Viewport/SinglePlayerWorld
onready var depth_label: Label = $GameWorldInfo/VBoxContainer/HBoxContainer/DepthLabel
onready var current_roadmap: Roadmap = Scenes.DEBUG_ROADMAP.instance()


func _ready():
	game_world.connect("depth_changed", self, "__on_depth_changed")
	
	game_world.current_roadmap = current_roadmap
	game_world.switch(GameWorld.DESCEND_MODE)


func __on_depth_changed(depth: int):
	depth_label.text = String(depth + 1)
