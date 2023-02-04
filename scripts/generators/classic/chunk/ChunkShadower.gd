extends Node2D
class_name ChunkShadower


var _chunk: Chunk
var _level: Level


func _init(chunk: Chunk, level: Level):
	_chunk = chunk
	_level = level
	_chunk.connect("known_status_changed", self, "__on_known_status_changed")


func __on_known_status_changed(new_status: int) -> void:
	do_shadow(_level, _chunk, new_status)


func do_shadow(level: Level, chunk: Chunk, status: int) -> void:
	var shadow_tile: int = ShadowMap.DARK_SHADOW
	match status:
		Chunk.KNOWN_STATUS:
			shadow_tile = ShadowMap.NO_SHADOW
		Chunk.NEARBY_STATUS:
			shadow_tile = ShadowMap.SMALL_SHADOW
	TileMapDraw.fill_rect(level.shadow_map, chunk.bounds, shadow_tile)
