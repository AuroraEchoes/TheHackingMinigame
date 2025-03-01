extends Button
class_name GridElement

var grid_position: Vector2 = Vector2.ZERO
var number: int = 0

func _ready() -> void:
    disabled = true
    pressed.connect(func(): get_parent().call("select_element", grid_position))

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
