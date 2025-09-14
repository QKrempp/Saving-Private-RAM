extends Node2D

const ENEMY: PackedScene = preload("res://Enemy.tscn")

signal enemy_spawned

@onready var _spawn_area_shape = $SpawnArea/CollisionShape2D
@onready var _spawn_timer = $SpawnTimer

var is_running: bool = true

func _ready() -> void:
	_spawn_timer.wait_time = 3.0 + 10.0 * randf()

func _on_spawn_timer_timeout() -> void:
	if is_running:
		var spawn_position = _spawn_area_shape.global_position
		var inst = ENEMY.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.start(spawn_position, Vector2.from_angle(randf()*2*PI))
		enemy_spawned.emit(inst)
		_spawn_timer.wait_time -= 0.1 * randf()


func _on_spawn_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running = false

func _on_spawn_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running = true
