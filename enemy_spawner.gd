extends Node2D

const ENEMY: PackedScene = preload("res://Enemy.tscn")

signal enemy_spawned

@onready var _spawn_area_shape = $SpawnArea/CollisionShape2D
@onready var _spawn_timer = $SpawnTimer

func _ready() -> void:
	_spawn_timer.wait_time = 3.0 + 10.0 * randf()

func _on_spawn_timer_timeout() -> void:
	var spawn_position = _spawn_area_shape.global_position
	var inst = ENEMY.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.start(spawn_position, Vector2.from_angle(randf()*2*PI))
	enemy_spawned.emit(inst)
