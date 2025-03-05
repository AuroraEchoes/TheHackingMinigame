extends RichTextLabel

# Subscribe to global events in _enter_tree() so that they can be called in _ready
func _enter_tree() -> void:
	Global.set_goal_text.connect(func(goal: String): text = "Goal: " + goal)
