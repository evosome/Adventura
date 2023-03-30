extends Miscellanous
class_name StairsUp


func on_interacted(by: Actor) -> void:
	if by is Player:
		level.ascend()
