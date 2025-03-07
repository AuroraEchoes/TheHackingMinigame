extends Node2D
class_name Grid

var grid_size: Vector2;
var grid: Array[GridElement];

func _init(size: Vector2) -> void:
    self.grid_size = size;
    for i in range(grid_size.x * grid_size.y):
        grid.append(null);

func idx(pos: Vector2) -> int:
    return int(pos.y) * int(grid_size.x) + int(pos.x)

func set_cell(pos: Vector2, cell: GridElement):
    grid[idx(pos)] = cell

func get_cell(pos: Vector2) -> GridElement:
    return grid[idx(pos)]

func get_row_or_col(row_or_col: Vector2) -> Array[GridElement]:
    var selected: Array[GridElement] = []
    var is_row: bool = row_or_col.x == 0
    if is_row:
        for i in range(0, grid_size.x):
            selected.push_back(get_cell(Vector2(i, row_or_col.y)))
    else:
        for i in range(0, grid_size.y):
            selected.push_back(get_cell(Vector2(row_or_col.x, i)))
    return selected
