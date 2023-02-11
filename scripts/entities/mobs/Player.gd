extends Humanoid
class_name Player

signal ascend
signal descend

var current: bool = true


func _input(event: InputEvent):
	if event.is_action_pressed("interact") \
	and level.current_selected_actor is KinematicEntity:
		interact(level.current_selected_actor)


func _process(_delta):
	var _velocity = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	move(_velocity)


static func create_from_data(player_data: PlayerData) -> Player:
	var player = Scenes.PLAYER.instance()
	return player


func spawn_on(level: Level, at_pos: Vector2) -> void:
	self.level = level
	
	at_pos = level.center_by_cell(at_pos)
	if current:
		self.level.spawn_current_actor(self, at_pos)
	else:
		self.level.spawn(self, at_pos)


func ascend() -> void:
	emit_signal("ascend")


func descend() -> void:
	emit_signal("descend")
