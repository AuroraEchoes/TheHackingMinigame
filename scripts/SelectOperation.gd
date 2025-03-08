extends HBoxContainer
class_name SelectOperation

@export var add: Button
@export var sub: Button

var unselected_stylebox: StyleBoxFlat = StyleBoxFlat.new()
var selected_stylebox: StyleBoxFlat = StyleBoxFlat.new()

var selected_operation: Operation

enum Operation {
	Noop,
	Add,
	Subtract,
}

func _ready() -> void:
	unselected_stylebox.bg_color = Color("#808080")
	selected_stylebox.bg_color = Color("#42a426")

	add.pressed.connect(func(): on_button_press("+"))
	sub.pressed.connect(func(): on_button_press("-"))

func on_button_press(button: String) -> void:
	Global.play_sound_event.emit(AudioManager.SoundEffect.KeyboardClick)
	add.add_theme_stylebox_override("normal", unselected_stylebox)
	sub.add_theme_stylebox_override("normal", unselected_stylebox)
	match button:
		"+":
			selected_operation = Operation.Add
			add.add_theme_stylebox_override("normal", selected_stylebox)
		"-":
			selected_operation = Operation.Subtract
			sub.add_theme_stylebox_override("normal", selected_stylebox)
	Global.select_operation.emit(selected_operation)

func get_operation() -> Operation:
	return self.selected_operation
