extends Control

static var active_scene: Node
static var _me_woohoooooo_dude_thats_me_like_whoah_thats_so_cool: Node

func _enter_tree() -> void:
	_me_woohoooooo_dude_thats_me_like_whoah_thats_so_cool = self

func _ready() -> void:
	var wow_this_is_a_dumb_way_of_doing_this: PackedScene = load("res://scenes/LevelSelect.tscn")
	set_active_scene(wow_this_is_a_dumb_way_of_doing_this.instantiate())

static func set_active_scene(new_scene: Node) -> void:
	if active_scene != null:
		active_scene.queue_free()
	_me_woohoooooo_dude_thats_me_like_whoah_thats_so_cool.add_child(new_scene)
