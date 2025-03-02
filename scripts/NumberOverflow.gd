extends Label
class_name NumberOverflow

@export var start: int = 0
@export var end: int = 64
@export var count_duration: float = 0.8
@export var duration: float = 1.5
@export var movement: Vector2 = Vector2(0, -100)
@export var fade_in: float = 0.3
@export var fade_out: float = 0.3

func _ready() -> void:
	get_tree().create_tween().tween_property(self, "global_position", global_position + movement, 20)
	modulate = Color(1, 1, 1, 0)
	get_tree().create_tween().tween_property(self, "modulate", Color(1, 1, 1, 1), fade_in)
	get_tree().create_tween().tween_method(func(n: int): text = str(n), start, end, count_duration)
	get_tree().create_timer(duration - fade_out).timeout.connect(func(): 
		get_tree().create_tween().tween_property(self, "modulate", Color(1, 1, 1, 0), fade_out).finished.connect(func(): 
			queue_free()))
