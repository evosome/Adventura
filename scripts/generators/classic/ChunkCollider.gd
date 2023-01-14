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


func set_level(new_level: Level) -> void:
	level = new_level
	level_camera = new_level.current_camera


static func create_for(level: Level, chunk: Chunk) -> ChunkCollider:
	var chunk_collider = Scenes.CHUNK_COLLIDER.instance() as ChunkCollider
	chunk_collider.level = level
	chunk_collider.chunk = chunk
	return chunk_collider
