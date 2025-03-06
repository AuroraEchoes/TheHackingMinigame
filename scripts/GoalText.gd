extends RichTextLabel

# Subscribe to global events in _enter_tree() so that they can be called in _ready
func _enter_tree() -> void:
    Global.update_goal_text.connect(update_goal_text)

func update_goal_text(level: LevelResource, grid: Grid) -> void:
    match level.goal:
        LevelResource.Goal.UnlockTile:
            var unlock_tile_val: int = grid.get_cell(level.unlock_tile_position).get_number()
            text = "Unlock the locked tile by setting it to 0 (currently " + str(unlock_tile_val) + ")"
        LevelResource.Goal.MakePointsEqual:
            var points: String = ""
            for point in level.points_to_equalise:
                var val: int = grid.get_cell(point).get_number()
                points += str(val)
                if point != level.points_to_equalise.back():
                    points += ", "
            text = "Set all the highlighted (?) tiles to the same number (currently " + points + ")"
        LevelResource.Goal.SumOfRowCol:
            var row_col: String
            var is_row: bool = level.selected_row_or_col.x == 0
            var sum: int = 0
            if is_row:
                row_col = "row"
                for i in range(0, grid.grid_size.x):
                    sum += grid.get_cell(Vector2(i, level.selected_row_or_col.y)).get_number()
            else:
                row_col = "column"
                for i in range(0, grid.grid_size.y):
                    sum += grid.get_cell(Vector2(level.selected_row_or_col.x, i)).get_number()
            text = "Make all numbers in the highlighted (?) " + row_col + " sum to " + str(level.sum_of_selected_row_col) + " (currently " + str(sum) + ")"
        LevelResource.Goal.AllOddAllEven:
            var row_col: String
            var odd_even: String
            if level.all_odd_in_selected_row_col:
                odd_even = "odd"
            else:
                odd_even = "even"
            var is_row: bool = level.selected_row_or_col.x == 0
            var n_odd: int = 0;
            var n_even: int = 0;
            if is_row:
                row_col = "row"
                for i in range(0, grid.grid_size.x):
                    if grid.get_cell(Vector2(i, level.selected_row_or_col.y)).get_number() % 2 == 0:
                        n_even += 1
                    else:
                        n_odd += 1
            else:
                row_col = "column"
                for i in range(0, grid.grid_size.y):
                    if grid.get_cell(Vector2(i, level.selected_row_or_col.y)).get_number() % 2 == 0:
                        n_even += 1
                    else:
                        n_odd += 1
            text = "Make all numbers in the highlighted (?)" + row_col + " " + odd_even + " (Currently " + str(n_odd) + " odd, " + str(n_even) + "even)"
