extends Humanoid
class_name Player


static func create_from_data(player_data: PlayerData) -> Player:
	var player = Scenes.PLAYER.instance()
	return player
