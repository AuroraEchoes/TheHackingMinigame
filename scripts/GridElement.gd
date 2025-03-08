extends Button
class_name GridElement

@onready var active_element: StyleBoxFlat = preload("res://resources/styles/active-element.tres")
@onready var deactivated_element: StyleBoxFlat = preload("res://resources/styles/deactivated-element.tres")
@onready var hovered_element: StyleBoxFlat = preload("res://resources/styles/hovered-element.tres")
@onready var selected_element: StyleBoxFlat = preload("res://resources/styles/selected-element.tres")
@onready var overflow_underflow: PackedScene = preload("res://scenes/OverflowUnderflow.tscn")
@onready var special_feature_scene: PackedScene = preload("res://scenes/SpecialTileIcon.tscn")
@onready var tooltip: PackedScene = preload("res://scenes/Tooltip.tscn")

var grid_position: Vector2 = Vector2.ZERO
var number: int = 0
var locked: bool = false
var number_tween: Array
var special_feature: GoalSpecialFeature = GoalSpecialFeature.None
var special_feature_node: Label

enum GoalSpecialFeature {
    None,
    LockedTile,
    Checksum,
    DataCorruption,
    PointEqualisation
}

func _ready() -> void:
    disabled = true
    pressed.connect(func(): get_parent().call("select_element", grid_position))
    if !locked:
        add_theme_stylebox_override("disabled", deactivated_element)
        add_theme_stylebox_override("hover", hovered_element)
        add_theme_stylebox_override("normal", active_element)

func set_grid_position(pos: Vector2) -> void:
    self.grid_position = pos

func get_grid_position() -> Vector2:
    return self.grid_position

func set_number(num: int, operation: SelectOperation.Operation, text_size_mod: float) -> void:
    # Overflow (adding and new < old)
    if operation == SelectOperation.Operation.Add and num < self.number:
        number_tween = range(self.number, 63)
        number_tween.append_array(range(0, num + 1))
        spawn_overflow(text_size_mod)
    # Underflow (subtracting and new > old)
    elif operation == SelectOperation.Operation.Subtract and num > self.number:
        number_tween = range(self.number, 0, -1)
        number_tween.append_array(range(63, num - 1, -1))
        spawn_undeflow(text_size_mod)
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
        add_theme_stylebox_override("normal", selected_element)
    elif get_theme_stylebox("normal") == selected_element:
        add_theme_stylebox_override("normal", active_element)

func set_special_feature(feature: GoalSpecialFeature, font_size_mod: float):
    special_feature = feature
    if special_feature_node != null:
        special_feature_node.queue_free()
    special_feature_node = special_feature_scene.instantiate();
    match feature:
        GoalSpecialFeature.LockedTile:
            special_feature_node.text = "󰌾"
        GoalSpecialFeature.Checksum:
            special_feature_node.text = ""
        GoalSpecialFeature.DataCorruption:
            special_feature_node.text = "󱔼"
        GoalSpecialFeature.PointEqualisation:
            special_feature_node.text = "󰫤 "

    special_feature_node.add_theme_font_size_override("font_size", int(32.0 * font_size_mod))
    special_feature_node.position.x += size.x * 0.75
    add_child(special_feature_node)

func get_special_feature_tooltip() -> String:
    match special_feature:
        GoalSpecialFeature.LockedTile:
            return "󰌾 Locked Tile"
        GoalSpecialFeature.Checksum:
            return "  Checksum Tile"
        GoalSpecialFeature.DataCorruption:
            return "󱔼  Data Corruption Tile"
        GoalSpecialFeature.PointEqualisation:
            return "󰫤 Parity Tile"
    return ""


func spawn_overflow(text_size_mod: float) -> void:
    spawn_overflow_or_underflow("Overflow!", text_size_mod)

func spawn_undeflow(text_size_mod: float) -> void:
    spawn_overflow_or_underflow("Underflow!", text_size_mod)

func spawn_overflow_or_underflow(label_text: String, text_size_mod: float) -> void:
    var overflow: Label = overflow_underflow.instantiate()
    overflow.text = label_text
    overflow.add_theme_font_size_override("font_size", int(text_size_mod * 24.0))
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
