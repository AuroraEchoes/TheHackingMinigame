extends Label

var alphabet = "₳฿₵ĐɆ₣₲ⱧłJ₭Ⱡ₥₦Ø₱QⱤ₴₮ɄV₩ӾɎⱫ"
@export var letter_change_time: float = 0.05
@export var letter_grid_size: Vector2i = Vector2i(15, 5);
var time_since_last_refresh: float = 0.0
var n_refreshes: int = 0
var text_to_reveal = "?????????????????-- T H E --?? H A C K I N G ?? MINI-GAME ????????????????"
var done_sound = false

func _ready():
	Global.close_screen_immediate.emit()
	Global.open_screen.emit()
	Global.transition_finished.connect(func(): 
		if !done_sound:
			Global.queue_sound_effect.emit(AudioManager.SoundEffect.ContinuousTyping)
			done_sound = true
	)

func _process(delta: float):
	time_since_last_refresh += delta
	if time_since_last_refresh >= letter_change_time:
		time_since_last_refresh = 0
		regenerate()

func regenerate():
	text = ""
	for row in range(letter_grid_size.y):
		for col in range(letter_grid_size.x):
			var idx: int = row * letter_grid_size.x + col
			if idx < (n_refreshes - 10) and idx < text_to_reveal.length():
				var character = text_to_reveal[idx]
				if character != "?":
					text += text_to_reveal[idx]
				else:
					text += alphabet[randi_range(0, 25)]
			else:
				text += alphabet[randi_range(0, 25)]
		text += "\n"
	if randi_range(0, 5) < 2:
		n_refreshes += 1
	if n_refreshes > 70:
		Global.noise_in_out.emit(func(): SceneManager.load_level_select())
