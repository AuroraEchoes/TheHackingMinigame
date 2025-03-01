extends GridContainer
class_name GenerateGrid

@export var screen_size: Vector2 = Vector2(4, 4);
@onready var grid: Grid;
@onready var grid_element: PackedScene = preload("res://scenes/GridElement.tscn")
# Vector2 or null (but gdscript sucks)
var selected_element
var row_active: bool = true

func _ready() -> void:
    self.grid = Grid.new(screen_size);
    self.columns = int(screen_size.x);
    for y in screen_size.y:
        for x in screen_size.x:
            var element: GridElement = grid_element.instantiate()
            element.set_number(randi_range(0, 64))
            element.set_grid_position(Vector2(x, y))
            grid.set_cell(Vector2(x, y), element)
            add_child(element)
    set_row_active(0)

func select_element(element_pos: Vector2) -> void:
    if selected_element == null:
        selected_element = element_pos
    elif element_pos == selected_element:
        selected_element = null
    else:
        var elem_a: GridElement = grid.get_cell(selected_element)
        var elem_b: GridElement = grid.get_cell(element_pos)
        elem_b.set_number(elem_a.get_number() + elem_b.get_number())
        selected_element = null
        if row_active:
            set_col_active(int(elem_b.get_grid_position().x))
        else:
            set_row_active(int(elem_b.get_grid_position().y))
        row_active = !row_active

func set_row_active(row_idx: int):
    for x in range(screen_size.x):
        for y in range(screen_size.y):
            if y == row_idx:
                grid.get_cell(Vector2(x, y)).disabled = false
            else:
                grid.get_cell(Vector2(x, y)).disabled = true

func set_col_active(col_idx: int):
    for x in range(screen_size.x):
        for y in range(screen_size.y):
            if x == col_idx:
                grid.get_cell(Vector2(x, y)).disabled = false
            else:
                grid.get_cell(Vector2(x, y)).disabled = true
