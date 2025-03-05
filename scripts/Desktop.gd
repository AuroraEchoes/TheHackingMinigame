extends ColorRect

@onready var notif_scene = preload("res://scenes/Notification.tscn")

func _enter_tree() -> void:
	Global.spawn_notification.connect(spawn_notification)

func spawn_notification(text: String):
	Global.play_sound_event.emit(AudioManager.SoundEffect.Notification)
	var notif: Notification = notif_scene.instantiate()
	notif.set_text(text)
	add_child(notif)
