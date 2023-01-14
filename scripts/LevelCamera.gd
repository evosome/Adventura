extends Camera2D
class_name LevelCamera

signal position_changed(new_position)

var followed_node: Node2D
var recent_position: Vector2

export (Vector2) var min_zoom: Vector2 = Vector2(0.1, 0.1)
export (Vector2) var max_zoom: Vector2 = Vector2(10.0, 10.0)
export (Vector2) var zoom_step: Vector2 = Vector2(0.1, 0.1)


func follow(node: Node2D) -> void:
	followed_node = node


func set_position(value: Vector2) -> void:
	if position != value:
		emit_signal("position_changed", value)
	.set_position(value)


func increase_zoom() -> void:
	var next_zoom = zoom + zoom_step
	if next_zoom < max_zoom:
		set_zoom(zoom + zoom_step)


func decrease_zoom() -> void:
	var next_zoom = zoom - zoom_step
	if next_zoom > min_zoom:
		set_zoom(next_zoom)


func _process(_delta):
	if followed_node and followed_node.position != position:
		set_position(followed_node.position)
	recent_position = position
