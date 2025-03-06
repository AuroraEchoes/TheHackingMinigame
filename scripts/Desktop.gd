extends ColorRect

@onready var notif_scene = preload("res://scenes/Notification.tscn")
@onready var penny_scene = preload("res://scenes/Tutorial.tscn")
var notification_queue: Array[Notification] = []

func _enter_tree() -> void:
	Global.spawn_notification.connect(spawn_notification)
	Global.spawn_penny.connect(spawn_penny)

func spawn_notification(text: String):
	spawn_generic_notif(text, notif_scene)

func spawn_penny(text: String):
	spawn_generic_notif(text, penny_scene)

func spawn_generic_notif(text: String, scene: PackedScene):
	var scn: Notification = scene.instantiate()
	scn.set_text(text)
	scn.done.connect(timeout_notif)
	if notification_queue.is_empty():
		Global.play_sound_event.emit(AudioManager.SoundEffect.Notification)
		add_child(scn)
	notification_queue.push_back(scn)
	
func timeout_notif(notif: Notification):
	notification_queue.remove_at(notification_queue.find(notif))
	if !notification_queue.is_empty():
		Global.play_sound_event.emit(AudioManager.SoundEffect.Notification)
		add_child(notification_queue.front())
