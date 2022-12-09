extends Camera2D
class_name LevelCamera

enum CameraModes {
	POINT,
	FOLLOW
}

signal speed_changed(new_speed)
signal position_changed(new_position)

export (int) var speed: int = 1 setget set_speed, get_speed
export (int) var min_speed: int = 0
export (int) var max_speed: int = 100
export (Vector2) var min_zoom: Vector2 = Vector2(0.1, 0.1)
export (Vector2) var max_zoom: Vector2 = Vector2(10.0, 10.0)
export (Vector2) var zoom_step: Vector2 = Vector2(0.1, 0.1)
export (CameraModes) var mode: int = CameraModes.POINT


func set_speed(value: int) -> void:
	if speed != value:
		emit_signal("speed_changed", value)
	speed = value


func set_position(value: Vector2) -> void:
	if position != value:
		emit_signal("position_changed", value)
	.set_position(value)


func get_speed() -> int:
	return speed


func increase_zoom() -> void:
	var next_zoom = zoom + zoom_step
	if next_zoom < max_zoom:
		set_zoom(zoom + zoom_step)


func decrease_zoom() -> void:
	var next_zoom = zoom - zoom_step
	if next_zoom > min_zoom:
		set_zoom(next_zoom)


func move(direction: Vector2) -> void:
	set_position(position + direction * speed)
