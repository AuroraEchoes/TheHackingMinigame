extends Resource
class_name LevelResource

@export var grid_size: Vector2i
@export var counterhack_moves: int
@export var goal: Goal
@export var goal_position: Vector2i

enum Goal {
	UnlockTile
}
