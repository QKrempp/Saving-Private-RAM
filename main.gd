extends Node2D

var rng := RandomNumberGenerator.new()
var upgrades: Array[Dictionary] = [
	{ "id": "speed_1",     "name": "Increase Speed by 10%" },
	{ "id": "fire_rate_1", "name": "Increase Fire Rate by 20%" },
	{ "id": "spray_shots_1", "name": "Increase bullets shot by 1 but decreases accuracy" },
	{ "id": "kaarsher_1", "name": "Clear all blood stains"}
]

signal clear_blood

@onready var _overlay_ram : RamOverlay = $Overlay/RAM
@onready var _main_character : MainCharacter = $MainCharacter
@onready var ui: CanvasLayer = $LevelUpUi
@onready var world: GridManager = $GridManager

func _ready() -> void:
	_main_character.global_position = world.player_pixel_pos
	rng.randomize()
	_main_character.level_up.connect(_on_player_level_up.bind())
	ui.option_chosen.connect(_on_upgrade_chosen)
	world.put_spawner_in_regions()
	
func _on_boss_win() -> void:
	var game_scene: PackedScene = load("res://MainMenu.tscn")
	get_tree().change_scene_to_packed(game_scene)

func _on_enemy_spawned(enemy: Enemy) -> void:
	enemy.entity_destroyed.connect(_main_character._on_enemy_killed.bind(enemy.xp_amount))
	
func _on_player_level_up() -> void:
	# 1) Pause
	get_tree().paused = true

	# 2) Tirage de 2 options distinctes
	var a := _pick_random_upgrade()
	var b := _pick_random_upgrade(a["id"])
	ui.show_two_options(a, b)

func _on_upgrade_chosen(upgrade_id: String) -> void:
	# 3) Appliquer
	apply_upgrade(upgrade_id)

	# 4) Fermer l'UI et reprendre
	ui.hide_ui()
	get_tree().paused = false
	
func _pick_random_upgrade(exclude_id: String = "") -> Dictionary:
	var pool := upgrades.filter(func(u): return u["id"] != exclude_id)
	if pool.is_empty():
		return { "id": "none", "name": "Aucune" }
	return pool[rng.randi_range(0, pool.size() - 1)]

func apply_upgrade(id: String) -> void:
	match id:
		"speed_1":
			_main_character.SPEED += 20
		"fire_rate_1":
			_main_character._fire_rate.wait_time *= 0.8
		"spray_shots_1":
			_main_character.bullet_number += 1
		"kaarsher_1":
			clear_blood.emit()
		_:
			push_warning("Upgrade inconnue: %s" % id)
