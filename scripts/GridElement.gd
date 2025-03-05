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
@onready var overflow_underflow: PackedScene = preload("res://scenes/OverflowUnderflow.tscn")
@onready var tooltip: PackedScene = preload("res://scenes/Tooltip.tscn")

var grid_position: Vector2 = Vector2.ZERO
var number: int = 0
var locked: bool = false
var number_tween: Array

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

func set_number(num: int, operation: SelectOperation.Operation) -> void:
	# Overflow (adding and new < old)
	if operation == SelectOperation.Operation.Add and num < self.number:
		number_tween = range(self.number, 63)
		number_tween.append_array(range(0, num + 1))
		spawn_overflow()
	# Underflow (subtracting and new > old)
	elif operation == SelectOperation.Operation.Subtract and num > self.number:
		number_tween = range(self.number, 0, -1)
		number_tween.append_array(range(63, num - 1, -1))
		spawn_undeflow()
	# Plain addition
	elif operation == SelectOperation.Operation.Add:
		number_tween = range(self.number, num + 1)
	elif operation == SelectOperation.Operation.Subtract:
		number_tween = range(self.number, num - 1, -1)
	self.number = num
	var length = min(2, 0.04 * number_tween.size())
	get_tree().create_tween().tween_method(func(progress: float): text = str(number_tween[floori(progress * (number_tween.size() - 1))]), 0.0, 1.0, length)

func set_number_immidiate(num: int) -> void:
	self.number = num
	text = str(self.number)

func get_number() -> int:
	return number

func _make_custom_tooltip(_for_text: String) -> Object:
	var tooltip_instance: Tooltip = tooltip.instantiate()
	var gen_grid: GenerateGrid = get_parent()
	if gen_grid.selected_element == null:
		tooltip_instance.setup(null, self, gen_grid.selected_operation, gen_grid.restart_criteria)
	else:
		tooltip_instance.setup(gen_grid.grid.get_cell(gen_grid.selected_element), self, gen_grid.selected_operation, gen_grid.restart_criteria)
	return tooltip_instance

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

func spawn_overflow() -> void:
	spawn_overflow_or_underflow("Overflow!")

func spawn_undeflow() -> void:
	spawn_overflow_or_underflow("Underflow!")


func spawn_overflow_or_underflow(label_text: String) -> void:
	var overflow: Label = overflow_underflow.instantiate()
	overflow.text = label_text
	print("Global position: " + str(global_position))
	var transparent = modulate
	transparent.a = 0
	var opaque = modulate
	overflow.modulate = transparent
	add_child(overflow)
	overflow.position = Vector2(size.x / 2.0 - overflow.size.x / 2.0, 0.0)
	get_tree().create_tween().tween_property(overflow, "modulate", opaque, 0.1).finished.connect(func():
		get_tree().create_timer(0.8).timeout.connect(func():
			get_tree().create_tween().tween_property(overflow, "modulate", transparent, 0.1).finished.connect(func():
				overflow.queue_free())))
