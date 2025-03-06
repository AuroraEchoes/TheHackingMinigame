extends ColorRect

@onready var notif_scene = preload("res://scenes/Notification.tscn")
@onready var penny_scene = preload("res://scenes/Tutorial.tscn")

func _enter_tree() -> void:
    Global.spawn_notification.connect(spawn_notification)
    Global.spawn_penny.connect(spawn_penny)

func spawn_notification(text: String):
    Global.play_sound_event.emit(AudioManager.SoundEffect.Notification)
    var notif: Notification = notif_scene.instantiate()
    notif.set_text(text)
    add_child(notif)

func spawn_penny(text: String):
    var penny: Notification = penny_scene.instantiate()
    penny.set_text(text)
    add_child(penny)
