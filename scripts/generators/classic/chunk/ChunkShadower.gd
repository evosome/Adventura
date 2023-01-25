extends Object
class_name ChunkShadower


func do_dark(chunk: Chunk) -> void:
	chunk.fill_shadow(ShadowMap.DARK_SHADOW)


func do_bright(chunk: Chunk) -> void:
	chunk.fill_shadow(ShadowMap.NO_SHADOW)


func do_half_bright(chunk:Chunk) -> void:
	chunk.fill_shadow(ShadowMap.SMALL_SHADOW)
