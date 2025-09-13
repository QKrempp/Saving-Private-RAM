extends Node2D

const ENNEMY: PackedScene = preload("res://Ennemy.tscn")

signal ennemy_spawned

@onready var _spawn_area_shape = $SpawnArea/CollisionShape2D

func _on_spawn_timer_timeout() -> void:
	var spawn_position = _spawn_area_shape.global_position
	var inst = ENNEMY.instantiate()
	get_owner().add_child(inst)
	inst.start(spawn_position, Vector2.from_angle(randf()))
	ennemy_spawned.emit(inst)
