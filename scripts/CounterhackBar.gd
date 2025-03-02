extends ProgressBar
class_name CounterhackBar

@export var moves_label: Label
var moves_total: int
var moves_remaining

func init() -> void:
	moves_remaining = moves_total
	max_value = moves_total
	value = moves_total - moves_remaining
	moves_label.text = moves_to_string()

# move can be taken
func take_move() -> bool:
	if moves_remaining > 0:
		moves_remaining -= 1
		value = moves_total - moves_remaining
		moves_label.text = moves_to_string()
		return true
	else:
		return false

func moves_to_string() -> String:
	return str(moves_remaining) + " moves"

func set_moves_total(moves: int):
	self.moves_total = moves
	init()
