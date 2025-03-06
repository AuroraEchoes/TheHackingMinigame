extends Resource
class_name LevelResource

@export var grid_size: Vector2i
@export var counterhack_moves: int
@export var goal: Goal
@export var unlock_tile_position: Vector2i
@export var points_to_equalise: Array[Vector2i]
@export var selected_row_or_col: Vector2i
@export var sum_of_selected_row_col: int
@export var all_odd_in_selected_row_col: bool
@export var restart_criteria: Array[GainRestart]
@export var hack_reduction_per_restart: int
@export var level_seed: int
@export var tutorial: bool

enum Goal {
	UnlockTile,
    MakePointsEqual,
    SumOfRowCol,
    AllOddAllEven
}
