extends Button
class_name GridElement

@onready var active_element: StyleBoxFlat = preload("res://resources/styles/active-element.tres")
@onready var deactivated_element: StyleBoxFlat = preload("res://resources/styles/deactivated-element.tres")
@onready var hovered_element: StyleBoxFlat = preload("res://resources/styles/hovered-element.tres")
@onready var selected_element: StyleBoxFlat = preload("res://resources/styles/selected-element.tres")
@onready var active_lock_element: StyleBoxTexture = preload("res://resources/styles/active-lock-element.tres")
@onready var deactivated_lock_element: StyleBoxTexture = preload("res://resources/styles/deactivated-lock-element.tres")
@onready var hovered_lock_element: StyleBoxTexture = preload("res://resources/styles/hovered-lock-element.tres")
@onready var selected_lock_element: StyleBoxTexture = preload("res://resources/styles/selected-lock-element.tres")

var grid_position: Vector2 = Vector2.ZERO
var number: int = 0
var locked: bool = false

func _ready() -> void:
	disabled = true
	pressed.connect(func(): get_parent().call("select_element", grid_position))
	if !locked:
		add_theme_stylebox_override("disabled", deactivated_element)
		add_theme_stylebox_override("hover", hovered_element)
		add_theme_stylebox_override("normal", active_element)

func lock() -> void:
	locked = true
	add_theme_stylebox_override("disabled", deactivated_lock_element)
	add_theme_stylebox_override("hover", hovered_lock_element)
	add_theme_stylebox_override("normal", active_lock_element)

func set_grid_position(pos: Vector2) -> void:
	self.grid_position = pos

func get_grid_position() -> Vector2:
	return self.grid_position

func set_number(num: int) -> void:
	self.number = num 
	text = str(number)

func get_number() -> int:
	return number

func set_tooltip(tooltip: String):
	self.tooltip_text = tooltip

func _get_tooltip(_at_position: Vector2) -> String:
	var gen_grid: GenerateGrid = get_parent()
	var operation: SelectOperation.Operation = gen_grid.select_operation.get_operation()
	if gen_grid.selected_element == null:
		match operation:
			SelectOperation.Operation.Add:
				return str(number) + " + ... = ?"
			SelectOperation.Operation.Subtract:
				return str(number) + " - ... = ?"
	else:
		var a = gen_grid.grid.get_cell(gen_grid.selected_element).get_number()
		match operation:
			SelectOperation.Operation.Add:
				return str(a) + " + " + str(number) + " = " + str(GenerateGrid.wrap_result(a + number))
			SelectOperation.Operation.Subtract:
				return str(a) + " + " + str(number) + " = " + str(GenerateGrid.wrap_result(a - number))
	return "??"

func on_selection_changed(selection):
	if selection != null and selection == grid_position:
		if locked:
			add_theme_stylebox_override("normal", selected_lock_element)
		else:
			add_theme_stylebox_override("normal", selected_element)
	elif get_theme_stylebox("normal") == selected_element:
		if locked:
			add_theme_stylebox_override("normal", active_lock_element)
		else:
			add_theme_stylebox_override("normal", active_element)
