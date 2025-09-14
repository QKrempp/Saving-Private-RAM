extends Node2D

const ENEMY: PackedScene = preload("res://Enemy.tscn")
const BOSS: PackedScene = preload("res://Boss.tscn")

signal enemy_spawned

@onready var _spawn_area_shape = $SpawnArea/CollisionShape2D
@onready var _spawn_timer = $SpawnTimer
@onready var _main_room : Node2D = $/root/Room

var is_boss_spawner: bool = false
var is_running: bool = true
var nb_enemy_spawned: int = 0

func _ready() -> void:
	_spawn_timer.wait_time = 3.0 + 10.0 * randf()

func _on_spawn_timer_timeout() -> void:
	if is_running:
		var inst: Enemy = null
		if nb_enemy_spawned == 15 and is_boss_spawner:
			inst = BOSS.instantiate()
			inst.win.connect(_main_room._on_boss_win.bind())
		else:
			inst = ENEMY.instantiate()
		var spawn_position = _spawn_area_shape.global_position
		get_tree().current_scene.add_child(inst)
		inst.start(spawn_position, Vector2.from_angle(randf() * 2 * PI))
		enemy_spawned.emit(inst)
		nb_enemy_spawned += 1
		_spawn_timer.wait_time -= 0.05 * randf()


func _on_spawn_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running = false

func _on_spawn_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running = true
