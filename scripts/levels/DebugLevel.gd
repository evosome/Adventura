extends Level
class_name DebugLevel


func _ready():
	var dummy = Scenes.DUMMY.instance()
	var stairs_down = Scenes.STAIRS_DOWN.instance()
	dummy.spawn(self, Vector2.ONE * 16)
	stairs_down.spawn(self, Vector2.ONE * -16)
