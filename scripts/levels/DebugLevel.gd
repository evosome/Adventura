extends Level
class_name DebugLevel


func _ready():
	var dummy = Scenes.DUMMY.instance()
	dummy.spawn_on(self, Vector2.ONE * 16)
