extends Miscellanous
class_name StairsDown


func on_interacted(by_actor: Node2D) -> void:
	if by_actor is Player:
		by_actor.descend()
