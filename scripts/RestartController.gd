extends VBoxContainer

@export var restart_button: Button
@export var criteria_label: RichTextLabel

func _enter_tree() -> void:
    Global.update_restart_criteria.connect(update_restart_criteria)

func update_restart_criteria(criteria: GainRestart):
    var goal: GainRestart.RestartCriteria = criteria.restart_criteria
    var total: int = criteria.restart_number
    var remaining: int = criteria.number_found
    var goal_name = "?"
    match goal:
        GainRestart.RestartCriteria.PrimeNumbers:
            goal_name = "Create prime numbers"
        GainRestart.RestartCriteria.PowersOfTwo:
            goal_name = "Create powers of 2"
        GainRestart.RestartCriteria.MultiplesOfThree:
            goal_name = "Create multiples of 3"
    var criteria_text: String = "Unlock Restart: " + goal_name + ": (" + str(remaining) + "/" + str(total) + ")"
    criteria_label.text = criteria_text
