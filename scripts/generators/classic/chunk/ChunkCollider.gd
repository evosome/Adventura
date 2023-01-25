extends Area2D
class_name ChunkCollider

var chunk: Chunk
var level: Level
onready var shadower: ChunkShadower = ChunkShadower.new()
onready var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	rectangle_shape.extents = chunk.get_rect_radius()
	collision_shape.shape = rectangle_shape


func __on_body_entered(body: Node2D):
	if not body is Player:
		return
	chunk.known_status = Chunk.KNOWN_STATUS
	for neighbour in chunk.neighbours:
		if not neighbour or (neighbour and neighbour.known_status == Chunk.KNOWN_STATUS):
			continue
		neighbour.known_status = Chunk.NEARBY_STATUS
		shadower.do_half_bright(neighbour)
	shadower.do_bright(chunk)


func __on_body_exited(body: Node2D):
	if not body is Player:
		return
	chunk.known_status = Chunk.NEARBY_STATUS
	for neighbour in chunk.neighbours:
		if not neighbour or (neighbour and neighbour.known_status == Chunk.KNOWN_STATUS):
			continue
		neighbour.known_status = Chunk.UNKNOWN_STATUS
	shadower.do_half_bright(chunk)


static func create_for(level: Level, chunk: Chunk) -> ChunkCollider:
	var chunk_collider = Scenes.CHUNK_COLLIDER.instance() as ChunkCollider
	chunk_collider.level = level
	chunk_collider.chunk = chunk
	return chunk_collider
