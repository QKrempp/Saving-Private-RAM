extends Node2D

const BULLET: PackedScene = preload("res://Bullet.tscn")

func _ready() -> void:
	$MainCharacter.shoot_bullet.connect($Overlay/RAM._on_shoot_bullet.bind())
	$EnemySpawner.ennemy_spawned.connect($Overlay/RAM._on_ennemy_spawned.bind())
