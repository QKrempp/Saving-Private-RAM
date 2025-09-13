extends Node2D

const BULLET: PackedScene = preload("res://Bullet.tscn")

@onready var _overlay_ram : RamOverlay = $Overlay/RAM
@onready var _main_character : MainCharacter = $MainCharacter
@onready var _enemy_spawner : Node2D = $EnemySpawner

#func _ready() -> void:
	#_enemy_spawner.enemy_spawned.connect(_overlay_ram._on_enemy_spawned.bind())
	#_enemy_spawner.enemy_spawned.connect(_on_enemy_spawned.bind())

func _on_enemy_spawned(enemy: Enemy) -> void:
	enemy.entity_destroyed.connect(_main_character._on_enemy_killed.bind(enemy.xp_amount))
