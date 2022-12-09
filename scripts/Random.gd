extends Node


func randint(from: int, to: int) -> int:
	return int(rand_range(from, to + 1))


func choice(array: Array):
	randomize()

	var size = array.size()
	if size != 0:
		return array[randi() % size]
	else:
		return null


func random_instance(array: Array) -> Object:
	if not array.empty():
		var packed_scene: PackedScene = choice(array)
		return packed_scene.instance() if packed_scene else null
	return null
