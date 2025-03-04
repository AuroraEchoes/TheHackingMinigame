extends ProgressBar
class_name CounterhackBar

@export var moves_label: Label
var moves_total: int
var moves_remaining: int
var hack_reduction: int

func _ready() -> void:
    Global.use_restart.connect(restart)

func setup(level: LevelResource) -> void:
    moves_total = level.counterhack_moves
    hack_reduction = level.hack_reduction_per_restart
    moves_remaining = moves_total
    max_value = moves_total
    value = moves_total - moves_remaining
    moves_label.text = moves_to_string()

func restart():
    moves_total -= hack_reduction
    moves_remaining = moves_total
    value = moves_total - moves_remaining
    moves_label.text = moves_to_string()

# return: move can be taken
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
