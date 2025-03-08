extends Control
class_name SceneManager

static var active_scene: Node
static var active_instance: SceneManager

@onready var loading_screen: PackedScene = preload("res://scenes/LoadingScreen.tscn")
@onready var level_select: PackedScene = preload("res://scenes/LevelSelect.tscn")
@onready var level: PackedScene = preload("res://scenes/Level.tscn")

func _enter_tree() -> void:
	active_instance = self
	Global.load_level.connect(load_level)

func _ready() -> void:
	load_loading_screen()

static func set_active_scene(new_scene: Node) -> void:
	if active_scene != null:
		active_scene.queue_free()
	active_instance.add_child(new_scene)
	active_scene = new_scene

static func load_level_select():
	set_active_scene(active_instance.level_select.instantiate())

static func load_loading_screen():
	set_active_scene(active_instance.loading_screen.instantiate())
	
func load_level(level_num: int):
	set_active_scene(level.instantiate())
	var level_manager: LevelManager = active_scene as LevelManager
	level_manager.load_level(level_num)
