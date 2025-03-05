extends Resource
class_name LevelResource

@export var grid_size: Vector2i
@export var counterhack_moves: int
@export var goal: Goal
@export var goal_position: Vector2i
@export var restart_criteria: Array[GainRestart]
@export var hack_reduction_per_restart: int
@export var level_seed: int

enum Goal {
	UnlockTile
}
