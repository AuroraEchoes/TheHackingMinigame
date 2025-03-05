extends ColorRect


func _ready() -> void:
	Global.use_restart.connect(restart)

func restart():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self.get_material(), "shader_parameter/shutdown_amount", 1.0, 1.0).set_trans(Tween.TransitionType.TRANS_SINE)
	tween.finished.connect(func():
		get_tree().create_timer(1.0).timeout.connect(func():
			get_tree().create_tween().tween_property(self.get_material(), "shader_parameter/shutdown_amount", 0.0, 1.0).set_trans(Tween.TransitionType.TRANS_SINE)))
