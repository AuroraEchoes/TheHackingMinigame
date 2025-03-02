extends GridContainer
class_name GenerateGrid

@export var level: LevelResource
@export var level_area_px: Vector2i = Vector2i(400, 400)
@onready var grid: Grid;
@onready var grid_element: PackedScene = preload("res://scenes/GridElement.tscn")
@onready var number_overflow: PackedScene = preload("res://scenes/NumberOverflow.tscn")
@onready var counterhack_bar: CounterhackBar = $"../CounterhackProgress"
@onready var select_operation: SelectOperation = $"../Operations"

var grid_size: Vector2
# Vector2 or null (but gdscript sucks)
var selected_element
var row_active: bool = true

signal selection_changed_signal(selected_element)

func _ready() -> void:
	load_level()

func load_level():
	var goal_text: String
	match level.goal:
		LevelResource.Goal.UnlockTile:
			goal_text = "Unlock the locked tile by setting it to 0"
	Global.set_goal_text.emit(goal_text)
	self.grid_size = level.grid_size
	self.grid = Grid.new(grid_size)
	self.columns = int(grid_size.x)
	self.counterhack_bar.set_moves_total(level.counterhack_moves)
	var element_side_len: int = int(min(level_area_px.x / grid_size.x, level_area_px.y / grid_size.y))
	var element_area: Vector2 = Vector2(element_side_len, element_side_len)
	var font_size: int = int((72.0 / 96.0) * element_side_len)
	for x in grid_size.x:
		for y in grid_size.y:
			var element: GridElement = grid_element.instantiate()
			element.custom_minimum_size = element_area
			element.update_minimum_size()
			element.add_theme_font_size_override("font_size", font_size)
			element.set_number(randi_range(0, 64))
			element.set_grid_position(Vector2(x, y))
			selection_changed_signal.connect(element.on_selection_changed)
			grid.set_cell(Vector2(x, y), element)
			add_child(element)
	grid.get_cell(level.goal_position).lock()
	set_row_active(0)

func select_element(element_pos: Vector2) -> void:
	if select_operation.get_operation() == SelectOperation.Operation.Noop:
		print("Select an operation!")
		return
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
		match select_operation.get_operation():
			SelectOperation.Operation.Add:
				result = elem_a.get_number() + elem_b.get_number()
			SelectOperation.Operation.Subtract:
				result = elem_a.get_number() - elem_b.get_number()
		result = wrap_result(result)
		elem_b.set_number(result)
		selected_element = null
		check_win_loss_criteria()
		if row_active:
			set_col_active(int(elem_b.get_grid_position().x))
		else:
			set_row_active(int(elem_b.get_grid_position().y))
		row_active = !row_active
	selection_changed_signal.emit(selected_element)

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
	if level.goal == LevelResource.Goal.UnlockTile && grid.get_cell(level.goal_position).get_number() == 0:
		var youWin: Label = $"/root/MarginContainer/YouWin"
		youWin.show()
	if counterhack_bar.moves_remaining <= 0:
		var youLose: Label = $"/root/MarginContainer/YouLose"
		youLose.show()


static func wrap_result(result: int) -> int:
	while result < 0:
		result += 64
	while result > 63:
		result -= 64
	return result

# theres a smarter way to do this
# but i am too drunk
func is_prime(result: int):
	for i in range(result):
		if result % i == 0:
			return true
	return false
