extends Camera2D
class_name CameraNode

var followed_node: Node2D

export (Vector2) var min_zoom: Vector2 = Vector2(0.1, 0.1)
export (Vector2) var max_zoom: Vector2 = Vector2(1.0, 1.0)
export (Vector2) var zoom_step: Vector2 = Vector2(0.1, 0.1)


func _input(event: InputEvent):
	if event.is_action_pressed("zoom_in"):
		decrease_zoom()
	if event.is_action_pressed("zoom_out"):
		increase_zoom()


func follow(node: Node2D) -> void:
	followed_node = node


func unfollow_current() -> void:
	followed_node = null


func increase_zoom() -> void:
	var next_zoom = zoom + zoom_step
	if next_zoom < max_zoom:
		set_zoom(zoom + zoom_step)


func decrease_zoom() -> void:
	var next_zoom = zoom - zoom_step
	if next_zoom > min_zoom:
		set_zoom(next_zoom)


func _process(_delta):
	if followed_node != null and followed_node.position != position:
		position = followed_node.position
