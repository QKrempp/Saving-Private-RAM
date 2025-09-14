class_name RamOverlay extends Label

@export var total_ram: float = 32
@export var ram_threshold_warning: float = 0.8
@export var default_text_color: Color = Color.WEB_GRAY
var used_ram: float = 0
var fps: int = 60

var player_x = 0
var player_y = 0
var player_r = 0

@onready var _player: MainCharacter = $/root/Room/MainCharacter

func _ready() -> void:
	add_theme_color_override("font_color", default_text_color)
	upate_overlay_text()

func _on_countable_entity_spawned(weight: float) -> void:
	used_ram += weight
	refresh_ram_counter()
	
func _on_countable_entity_destroyed(weight: float) -> void:
	used_ram -= weight
	refresh_ram_counter()

func refresh_ram_counter() -> void:
	var ram_pct: float = used_ram / total_ram
	if ram_pct > ram_threshold_warning:
		fps = 10 + int(50.0 * (1.0 - ram_pct) / (1.0 - ram_threshold_warning))
		add_theme_color_override("font_color", Color.RED)
	else:
		fps = 60
		add_theme_color_override("font_color", default_text_color)
	Engine.max_fps = fps
	if used_ram >= total_ram:
		var game_scene: PackedScene = load("res://MainMenu.tscn")
		get_tree().change_scene_to_packed(game_scene)
	upate_overlay_text()

func upate_overlay_text() -> void:
	text = "Position X: %.1f, Y: %.1f\nRotation: %.1f°\nAvailable RAM: %.1f / %.1f Mo\nFPS: %d" % [player_x, player_y, player_r, used_ram, total_ram, fps]

func _on_update_timer_timeout() -> void:
	player_x = _player.global_position.x
	player_y = _player.global_position.y
	player_r = _player.rotation * 360 / (2 * PI)
	upate_overlay_text()
