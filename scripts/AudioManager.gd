extends AudioStreamPlayer
class_name AudioManager

enum SoundEffect {
	KeyboardClick,
	Notification
}

@onready var keyboard_clicks: Array[AudioStream] = [
	preload("res://assets/audio/sfx/keyboard-click-1.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-2.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-3.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-4.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-5.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-6.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-7.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-8.mp3"),
	preload("res://assets/audio/sfx/keyboard-click-9.mp3"),
]

@onready var notification_sound: AudioStream = preload("res://assets/audio/sfx/notification.mp3")

func _ready() -> void:
	Global.play_sound_event.connect(play_sound)

func play_sound(sound: SoundEffect):
	match sound:
		SoundEffect.KeyboardClick:
			play_keyboard_sound()
		SoundEffect.Notification:
			play_audio_stream(notification_sound)

func play_keyboard_sound():
	var sound_idx: int = randi_range(0, keyboard_clicks.size() - 1)
	var sound: AudioStream = keyboard_clicks[sound_idx]
	play_audio_stream(sound)

func play_audio_stream(audio_stream: AudioStream):
	stream = audio_stream
	play()
