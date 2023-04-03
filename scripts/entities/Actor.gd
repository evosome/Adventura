extends KinematicBody2D
class_name Actor


var current: bool = false


func get_actor_distance(actor: Actor) -> float:
	return position.distance_to(actor.position)


func get_actor_direction(actor: Actor) -> Vector2:
	return position.direction_to(actor.position)


func get_actor_angle(actor: Actor) -> float:
	return position.angle_to_point(actor.position)


func get_distance_to(point: Vector2) -> float:
	return position.distance_to(point)


func get_direction_to(point: Vector2) -> Vector2:
	return position.direction_to(point)


func can_hit(actor: Actor) -> bool:
	return true


func can_select(actor: Actor) -> bool:
	return true


func can_collide(actor: Actor) -> bool:
	return true


func can_interact(actor: Actor) -> bool:
	return true


func move(direction: Vector2) -> void:
	pass


func hit(actor: Actor) -> void:
	pass


func select(actor: Actor) -> void:
	pass


func unselect(actor: Actor) -> void:
	pass


func collide(actor: Actor) -> void:
	pass


func interact(actor: Actor) -> void:
	pass


func highlight() -> void:
	pass


func unhighlight() -> void:
	pass


func destroy() -> void:
	pass


func on_hit(by: Actor) -> void:
	pass


func on_selected(by: Actor) -> void:
	pass


func on_unselected(by: Actor) -> void:
	pass


func on_collided(by: Actor) -> void:
	pass


func on_interacted(by: Actor) -> void:
	pass
