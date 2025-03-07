extends Control
class_name Notification

@export var label: RichTextLabel
@export var in_out_time: float = 1.0
@export var show_time = 3.0
signal done(me: Notification)

func set_text(new_text: String):
    label.text = "  " + new_text 

func _ready():
    global_position = Vector2(get_window().size) - Vector2(0, (size.y + 100))
    var to_translate: Vector2 = Vector2(max(label.size.x, size.x), 0.0)
    get_tree().create_tween().tween_property(self, "position", position - to_translate, in_out_time).finished.connect(func():
        get_tree().create_timer(show_time).timeout.connect(func():
            get_tree().create_tween().tween_property(self, "position", position + to_translate, in_out_time).finished.connect(func():
                done.emit(self)
                queue_free())))
