extends Node

signal update_goal_text(level: LevelResource, grid: Grid)
signal enable_restart()
signal disable_restart()
signal use_restart()
signal update_restart_criteria(criteria: GainRestart)
signal play_sound_event(sound: AudioManager.SoundEffect)
signal queue_sound_effect(sound: AudioManager.SoundEffect)
signal spawn_notification(text: String)
signal spawn_penny(text: String)
signal select_operation(operation: SelectOperation.Operation)
signal load_level(level: int)
signal go_to_level_select()
signal close_screen_immediate()
signal open_screen()
signal noise_in_out(to_call: Callable)
signal transition_finished()

var active_scene: Node

var completed_levels: Array[int]

func set_active_scene(new_scene: Node):
	active_scene.queue_free()
	add_child(new_scene)
