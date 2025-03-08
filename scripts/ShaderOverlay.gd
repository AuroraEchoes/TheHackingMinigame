extends ColorRect


func _ready() -> void:
	Global.go_to_level_select.connect(func(): noise_in_out(func(): SceneManager.load_level_select()))
	Global.use_restart.connect(func(): restart(func(): pass))
	Global.close_screen_immediate.connect(close_screen_immediate)
	Global.open_screen.connect(open_screen)
	Global.noise_in_out.connect(noise_in_out)
	
func restart(to_call: Callable):
	var tween: Tween = get_tree().create_tween()
	Global.play_sound_event.emit(AudioManager.SoundEffect.PowerOff)
	tween.tween_property(self.get_material(), "shader_parameter/shutdown_amount", 1.0, 1.0).set_trans(Tween.TransitionType.TRANS_SINE)
	tween.finished.connect(func():
		to_call.call()
		get_tree().create_timer(0.35).timeout.connect(open_screen))

func open_screen():
	Global.play_sound_event.emit(AudioManager.SoundEffect.PowerOn)
	get_tree().create_timer(1.7).timeout.connect(func():
		get_tree().create_tween().tween_property(self.get_material(), "shader_parameter/shutdown_amount", 0.0, 1.8).set_trans(Tween.TransitionType.TRANS_SINE).finished.connect(func():
			Global.transition_finished.emit()))

func close_screen_immediate():
	material.set_shader_parameter("shutdown_amount", 1.0)

func noise_in_out(to_call: Callable):
	var tween: Tween = get_tree().create_tween()
	Global.play_sound_event.emit(AudioManager.SoundEffect.StaticFade)
	tween.tween_property(self.get_material(), "shader_parameter/noise_amount", 1.0, 0.3)
	tween.finished.connect(func():
		to_call.call()
		get_tree().create_tween().tween_property(self.get_material(), "shader_parameter/noise_amount", 0.0, 0.3))
