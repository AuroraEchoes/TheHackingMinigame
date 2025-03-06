extends Button

# i am going to hell for this
# but…
# that’s ok
# because
# i was already gonna
# so
# eh
# they forgor to teach me fear of god

@export var level_to_load: int

func _ready() -> void:
	pressed.connect(func(): Global.load_level.emit(level_to_load))
