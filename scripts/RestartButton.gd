extends Button

func _ready() -> void:
    disabled = true
    Global.enable_restart.connect(func(): disabled = false)
    Global.disable_restart.connect(func(): disabled = true)
    pressed.connect(func(): Global.use_restart.emit())
    Global.use_restart.connect(func(): disabled = true)
