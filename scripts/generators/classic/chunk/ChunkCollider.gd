extends Area2D
class_name ChunkCollider

var chunk: Chunk
onready var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	rectangle_shape.extents = chunk.get_global_radius()
	collision_shape.shape = rectangle_shape


func __on_body_entered(body: Node2D):
	if not body is Player:
		return
	chunk.set_known_status(Chunk.KNOWN_STATUS)
	for neighbour in chunk.neighbours:
		if not neighbour or (neighbour and neighbour.known_status == Chunk.KNOWN_STATUS):
			continue
		neighbour.set_known_status(Chunk.NEARBY_STATUS)


func __on_body_exited(body: Node2D):
	if not body is Player:
		return
	chunk.set_known_status(Chunk.NEARBY_STATUS)


static func create_for(chunk: Chunk) -> ChunkCollider:
	var chunk_collider = Scenes.CHUNK_COLLIDER.instance() as ChunkCollider
	chunk_collider.chunk = chunk
	return chunk_collider
