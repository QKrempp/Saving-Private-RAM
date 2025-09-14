extends Control

@onready var btn_play: Button = $VBoxContainer/Play
@onready var btn_quit: Button = $VBoxContainer/Quit

func _ready() -> void:
	btn_play.pressed.connect(_on_play_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	var game_scene: PackedScene = load("res://Main.tscn")
	get_tree().change_scene_to_packed(game_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
