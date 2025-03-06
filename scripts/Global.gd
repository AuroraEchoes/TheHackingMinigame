extends Node

signal set_goal_text(text: String)
signal enable_restart()
signal disable_restart()
signal use_restart()
signal update_restart_criteria(criteria: GainRestart)
signal play_sound_event(sound: AudioManager.SoundEffect)
signal spawn_notification(text: String)
signal select_operation(operation: SelectOperation.Operation)
signal load_level(level: int)

var active_scene: Node

func set_active_scene(new_scene: Node):
	active_scene.queue_free()
	add_child(new_scene)
