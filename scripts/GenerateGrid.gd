extends GridContainer
class_name GenerateGrid

var level: LevelResource
@export var level_area_px: Vector2i = Vector2i(400, 400)
@onready var grid: Grid;
@onready var grid_element: PackedScene = preload("res://scenes/GridElement.tscn")
@onready var counterhack_bar: CounterhackBar = $"../CounterhackProgress"
var selected_operation: SelectOperation.Operation = SelectOperation.Operation.Noop

var grid_size: Vector2
# Vector2 or null (but gdscript sucks)
var selected_element
var row_active: bool = true
var restart_criteria: GainRestart

signal selection_changed_signal(selected_element)

func _ready() -> void:
    custom_minimum_size = level_area_px
    Global.use_restart.connect(on_use_restart_signal)
    Global.select_operation.connect(func(op: SelectOperation.Operation): selected_operation = op)

func unload_level():
    if grid != null:
        for tile in grid.grid:
            tile.queue_free()

func load_level():
    seed(level.level_seed)
    self.grid_size = level.grid_size
    self.grid = Grid.new(grid_size)
    self.columns = int(grid_size.x)
    self.counterhack_bar.setup(level)
    set_next_restart()
    var element_side_len: int = int(min(level_area_px.x / grid_size.x, level_area_px.y / grid_size.y))
    var element_area: Vector2 = Vector2(element_side_len, element_side_len)
    var font_size: int = int((72.0 / 96.0) * element_side_len)
    for y in grid_size.y:
        for x in grid_size.x:
            var element: GridElement = grid_element.instantiate()
            element.custom_minimum_size = element_area
            element.update_minimum_size()
            element.add_theme_font_size_override("font_size", font_size)
            element.set_number_immidiate(randi_range(0, 63))
            element.set_grid_position(Vector2(x, y))
            element.name = "Element (" + str(x) + ", " + str(y) + ")"
            selection_changed_signal.connect(element.on_selection_changed)
            grid.set_cell(Vector2(x, y), element)
            add_child(element)
    grid.get_cell(level.unlock_tile_position).lock()
    Global.update_goal_text.emit(level, grid)
    set_row_active(0)

func select_element(element_pos: Vector2) -> void:
    if selected_operation == SelectOperation.Operation.Noop:
        Global.spawn_notification.emit("Select an operation first")
        return
    Global.play_sound_event.emit(AudioManager.SoundEffect.KeyboardClick)
    if selected_element == null:
        selected_element = element_pos
    elif element_pos == selected_element:
        selected_element = null
    else:
        if !counterhack_bar.take_move():
            return

        var elem_a: GridElement = grid.get_cell(selected_element)
        var elem_b: GridElement = grid.get_cell(element_pos)
        var result: int = 0
        match selected_operation:
            SelectOperation.Operation.Add:
                result = elem_a.get_number() + elem_b.get_number()
            SelectOperation.Operation.Subtract:
                result = elem_a.get_number() - elem_b.get_number()
        result = wrap_result(result)
        restart_criteria.update_with_move(result)
        elem_b.set_number(result, selected_operation)
        selected_element = null
        check_win_loss_criteria()
        if row_active:
            set_col_active(int(elem_b.get_grid_position().x))
        else:
            set_row_active(int(elem_b.get_grid_position().y))
        row_active = !row_active
    selection_changed_signal.emit(selected_element)
    Global.update_goal_text.emit(level, grid)

func set_row_active(row_idx: int):
    for x in range(grid_size.x):
        for y in range(grid_size.y):
            if y == row_idx:
                grid.get_cell(Vector2(x, y)).disabled = false
            else:
                grid.get_cell(Vector2(x, y)).disabled = true

func set_col_active(col_idx: int):
    for x in range(grid_size.x):
        for y in range(grid_size.y):
            if x == col_idx:
                grid.get_cell(Vector2(x, y)).disabled = false
            else:
                grid.get_cell(Vector2(x, y)).disabled = true

func wrap_vector(vec: Vector2) -> Vector2:
    if (vec.x >= grid_size.x):
        vec.x -= grid_size.x
    if (vec.x < 0):
        vec.x += grid_size.x
    if (vec.y >= grid_size.y):
        vec.y -= grid_size.y
    if (vec.y < 0):
        vec.y += grid_size.y
    return vec

func check_win_loss_criteria():
    if counterhack_bar.moves_remaining <= 0:
        if restart_criteria.done():
            Global.spawn_notification.emit("You have no time. RESTART, NOW!")
        else:
            Global.spawn_notification.emit("They’ve caught up. RUN!")
    else:
        is_goal_complete(level.goal)

func is_goal_complete(goal: LevelResource.Goal) -> bool:
    match goal:
        LevelResource.Goal.UnlockTile:
            return grid.get_cell(level.unlock_tile_position).get_number() == 0
        LevelResource.Goal.MakePointsEqual:
            var base_val: int = grid.get_cell(level.points_to_equalise.front()).get_number()
            for pos: Vector2i in level.points_to_equalise:
                if grid.get_cell(pos).get_number() != base_val:
                    return false
            return true
        LevelResource.Goal.SumOfRowCol:
            var is_row: bool = level.selected_row_or_col.x == 0
            var sum: int = 0
            if is_row:
                for i in range(0, grid_size.x):
                    sum += grid.get_cell(Vector2(i, level.selected_row_or_col.y)).get_number()
            else:
                for i in range(0, grid_size.y):
                    sum += grid.get_cell(Vector2(level.selected_row_or_col.x, i)).get_number()
            return sum == level.sum_of_selected_row_col
        LevelResource.Goal.AllOddAllEven:
            var is_row: bool = level.selected_row_or_col.x == 0
            if is_row:
                for i in range(0, grid_size.x):
                    var cell_val: int = grid.get_cell(Vector2(i, level.selected_row_or_col.y)).get_number()
                    var even = cell_val % 2 == 0
                    if (even and level.all_odd_in_selected_row_col) or (!even and !level.all_odd_in_selected_row_col):
                        return false
            else:
                for i in range(0, grid_size.y):
                    var cell_val: int = grid.get_cell(Vector2(level.selected_row_or_col.x, i)).get_number()
                    var even = cell_val % 2 == 0
                    if (even and level.all_odd_in_selected_row_col) or (!even and !level.all_odd_in_selected_row_col):
                        return false
            return true
    return false


static func wrap_result(result: int) -> int:
    while result < 0:
        result += 64
    while result > 63:
        result -= 64
    return result

func on_use_restart_signal():
    set_next_restart()

func set_next_restart():
    if level.restart_criteria.size() > 0:
        restart_criteria = level.restart_criteria.front()
        level.restart_criteria.pop_front()
        Global.update_restart_criteria.emit(restart_criteria)
    elif restart_criteria.restart_criteria != GainRestart.RestartCriteria.NoMoreAvailable:
        restart_criteria.restart_criteria = GainRestart.RestartCriteria.NoMoreAvailable
        Global.update_restart_criteria.emit(restart_criteria)
