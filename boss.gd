class_name Boss
extends Enemy

signal enemy_spawned
signal win

const ENEMY: PackedScene = preload("res://Enemy.tscn")
# Boss-specific constants
@export var attack_radius := 400.0
@export var dash_speed := 500.0
@export var dash_windup := 0.4
@export var dash_duration := 0.3

const BULLET := preload("res://Bullet.tscn")

@onready var _attack_cd: Timer = $AttackCD
@onready var _dash_windup_t: Timer = $DashWindup
@onready var _dash_duration_t: Timer = $DashDuration
@onready var _cast_duration_t: Timer = $CastDuration
@onready var _sprite_boss: AnimatedSprite2D = $AnimatedSprite2D
@onready var _dash_dir := Vector2.ZERO
@onready var is_attacking := false
@onready var current_attack := 2

func _ready() -> void:
	health = 25
	_attack_cd.timeout.connect(_on_attack_cd_timeout)
	_dash_windup_t.timeout.connect(_on_dash_windup_timeout)
	_dash_duration_t.timeout.connect(_on_dash_duration_timeout)
	_cast_duration_t.timeout.connect(_make_zombies_appear)

func _physics_process(delta: float) -> void:
	if health <= 0:
		emit_signal("win")
		queue_free()
	if is_attacking:
		move_and_slide()
		return
	
	if _attack_cd.is_stopped():
		velocity = Vector2.ZERO
		_start_attack()
		return
	super._physics_process(delta)

func _start_attack() -> void:
	var choice_list = ["DASH", "DASH", "DASH", "SPAWN"]
	var incoming_attack = choice_list[current_attack]
	current_attack = (current_attack + 1) % 4
	match incoming_attack:
		"DASH": _start_dash()
		"SPAWN": _spawn_zombies()

func _start_dash() -> void:
	if not target: return
	is_attacking = true
	_dash_dir = (global_position.direction_to(target.global_position)).normalized()
	_sprite_boss.play("DashWindup")  # anim spéciale
	_dash_windup_t.start()

func _on_dash_windup_timeout() -> void:
	_sprite_boss.play("IdleZombie1")
	velocity = _dash_dir * dash_speed
	_dash_duration_t.start()

func _on_dash_duration_timeout() -> void:
	is_attacking = false
	velocity = Vector2.ZERO
	_sprite_boss.play("IdleZombie1")
	_attack_cd.start()
	
func _spawn_zombies() -> void:
	if not target: return
	is_attacking = true
	_sprite_boss.play("ShoutBoss")
	_cast_duration_t.start()

func _make_zombies_appear() -> void:
	var spawn_position = position
	var pos_list = [Vector2(100, 0), Vector2(0, 100), Vector2(-100, 0), Vector2(0, -100)]
	for pos in pos_list:
		var inst = ENEMY.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.start(pos + spawn_position, Vector2.from_angle(randf()*2*PI))
		enemy_spawned.emit(inst)
	_dash_duration_t.start()
	
func _on_attack_cd_timeout() -> void:
	# rien à faire, juste débloquer
	pass
