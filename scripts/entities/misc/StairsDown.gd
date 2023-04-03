extends Miscellanous
class_name StairsDown


func on_interacted(by: Actor) -> void:
	if by is Player:
		level.descend()
