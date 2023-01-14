extends Roadmap


func get_level(depth: int) -> Level:
	return Scenes.TEST_LEVEL.instance() as Level


func get_generator(depth: int) -> LevelGenerator:
	return Scenes.CLASSIC_GENERATOR.instance() as LevelGenerator
