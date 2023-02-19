extends Miscellanous
class_name StairsUp


func on_interacted(by_actor: Node2D) -> void:
	if by_actor is Player:
		level.ascend()
