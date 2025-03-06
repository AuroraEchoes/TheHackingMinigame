extends Control
class_name Notification

@export var label: Label

signal done(me: Notification)

func set_text(new_text: String):
	label.text = "  " + new_text 

func _ready():
	global_position = Vector2(get_window().size) - Vector2(0, (size.y + 100))
	get_tree().create_tween().tween_property(self, "position", position + Vector2(-size.x, 0), 1.0).finished.connect(func():
		get_tree().create_timer(3.0).timeout.connect(func():
			get_tree().create_tween().tween_property(self, "position", position - Vector2(-size.x, 0), 1.0).finished.connect(func():
				done.emit(self)
				queue_free())))
