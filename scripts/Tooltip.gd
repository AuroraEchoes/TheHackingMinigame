extends PanelContainer
class_name Tooltip

@export var label: Label

func _ready() -> void:
	var panel: PopupPanel = get_parent()
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	panel.transparent_bg = true
	panel.transparent = true

func setup(selected_tile: GridElement, hovered_tile: GridElement, operation: SelectOperation.Operation, restart_goal: GainRestart):
	# tutorialling
	if operation == null:
		label.text = "Select an operation!"
	# no selected tile, just hovering over one
	elif selected_tile == null:
		match operation:
			SelectOperation.Operation.Add:
				label.text = str(hovered_tile.get_number()) + " + …  = ?"
			SelectOperation.Operation.Subtract:
				label.text = str(hovered_tile.get_number()) + " - …  = ?"
	else:
		var result: int
		match operation:
			SelectOperation.Operation.Add:
				result = GenerateGrid.wrap_result(selected_tile.get_number() + hovered_tile.get_number())
				label.text = str(selected_tile.get_number()) + " + " + str(hovered_tile.get_number()) + " = " + str(result)
			SelectOperation.Operation.Subtract:
				result = GenerateGrid.wrap_result(selected_tile.get_number() - hovered_tile.get_number())
				label.text = str(selected_tile.get_number()) + " - " + str(hovered_tile.get_number()) + " = " + str(GenerateGrid.wrap_result(selected_tile.get_number() - hovered_tile.get_number()))
		if GainRestart.is_prime(result) and restart_goal.restart_criteria == GainRestart.RestartCriteria.PrimeNumbers:
			label.text += "\n󰄬 Is prime"
		if GainRestart.is_power_of_two(result) and restart_goal.restart_criteria == GainRestart.RestartCriteria.PowersOfTwo:
			label.text += "\n󰄬 Is a power of 2"
		if GainRestart.is_multiple_of_three(result) and restart_goal.restart_criteria == GainRestart.RestartCriteria.MultiplesOfThree:
			label.text += "\n󰄬 Is a multiple of 3"
