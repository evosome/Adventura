extends Humanoid
class_name Player

signal ascend
signal descend

var current: bool = true


func _process(delta):
	var _velocity = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	move(_velocity)


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	if current:
		self.level.spawn_current_actor(self, at_pos)
	else:
		self.level.spawn(self, at_pos)


static func create_from_data(player_data: PlayerData) -> Player:
	var player = Scenes.PLAYER.instance()
	return player
