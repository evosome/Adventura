extends Area2D
class_name ChunkCollider


var chunk: Chunk
var level: Level setget set_level
var level_camera: LevelCamera
onready var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	rectangle_shape.extents = chunk.get_rect_radius()
	collision_shape.shape = rectangle_shape


func __on_input_event(
	viewport: Viewport,
	event: InputEvent,
	shape_idx: int) -> void:

	if event.is_action_pressed("left_click") \
	and level_camera.mode == LevelCamera.CameraModes.POINT:
		level_camera.position = chunk.get_rect_center()


func set_level(new_level: Level) -> void:
	level = new_level
	level_camera = new_level.current_camera


static func create_for(level: Level, chunk: Chunk) -> ChunkCollider:
	var chunk_collider = Resources.CHUNK_COLLIDER.instance() as ChunkCollider
	chunk_collider.level = level
	chunk_collider.chunk = chunk
	return chunk_collider
