extends Control
class_name LevelManager

@export var levels: Array[LevelResource]
@export var generate_grid: GenerateGrid

func load_level(level: int):
	generate_grid.unload_level()
	generate_grid.level = levels[level - 1]
	generate_grid.load_level()
