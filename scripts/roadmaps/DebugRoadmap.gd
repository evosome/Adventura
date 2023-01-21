extends Roadmap
class_name DebugRoadmap


func get_level(depth: int) -> Level:
	if depth < 5:
		return Scenes.DEBUG_LEVEL.instance() as Level
	else:
		return Scenes.TEST_LEVEL.instance() as Level


func get_generator(depth: int) -> LevelGenerator:
	if depth >= 5:
		return Scenes.DEBUG_GENERATOR.instance() as LevelGenerator
	return null
