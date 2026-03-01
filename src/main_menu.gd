extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/levels/level0.tscn")
	)
	quit_button.pressed.connect(func():
		get_tree().quit()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
