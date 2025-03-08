extends AudioStreamPlayer
class_name AudioManager

enum SoundEffect {
	KeyboardClick,
	Notification,
	PowerOn,
	PowerOff,
	ContinuousTyping,
	StaticFade
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
@onready var power_off: AudioStream = preload("res://assets/audio/sfx/power-off.mp3")
@onready var power_on: AudioStream = preload("res://assets/audio/sfx/power-on.mp3")
@onready var continuous_typing: AudioStream = preload("res://assets/audio/sfx/continuous-typing.mp3")
@onready var static_fade: AudioStream = preload("res://assets/audio/sfx/static-fade.mp3")

var queue

func _ready() -> void:
	Global.play_sound_event.connect(play_sound)
	Global.queue_sound_effect.connect(play_queued)
	finished.connect(try_play_next_queued)

func play_sound(sound: SoundEffect):
	match sound:
		SoundEffect.KeyboardClick:
			play_keyboard_sound()
		SoundEffect.Notification:
			play_audio_stream(notification_sound)
		SoundEffect.PowerOff:
			play_audio_stream(power_off)
		SoundEffect.PowerOn:
			play_audio_stream(power_on)
		SoundEffect.ContinuousTyping:
			play_audio_stream(continuous_typing)
		SoundEffect.StaticFade:
			play_audio_stream(static_fade)

func play_queued(sound: SoundEffect):
	queue = sound

func try_play_next_queued():
	if queue != null:
		play_sound(queue)
		queue = null

func play_keyboard_sound():
	var sound_idx: int = randi_range(0, keyboard_clicks.size() - 1)
	var sound: AudioStream = keyboard_clicks[sound_idx]
	play_audio_stream(sound)

func play_audio_stream(audio_stream: AudioStream):
	stream = audio_stream
	play()
