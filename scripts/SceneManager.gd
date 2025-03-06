extends Control

static var active_scene: Node
static var active_instance: Node

@onready var level_select: PackedScene = preload("res://scenes/LevelSelect.tscn")
@onready var level: PackedScene = preload("res://scenes/Level.tscn")

var level_active: bool = false

func _enter_tree() -> void:
    active_instance = self
    Global.load_level.connect(load_level)

func _ready() -> void:
    set_active_scene(level_select.instantiate())

static func set_active_scene(new_scene: Node) -> void:
    if active_scene != null:
        active_scene.queue_free()
    active_instance.add_child(new_scene)
    active_scene = new_scene

func load_level(level_num: int):
    if !level_active:
        set_active_scene(load("res://scenes/Level.tscn").instantiate())
        level_active = true
    var level_manager: LevelManager = active_scene
    level_manager.load_level(level_num)
