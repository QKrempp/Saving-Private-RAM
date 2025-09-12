extends CountableEntity

const SPEED: int = 100
const BULLET: PackedScene = preload("res://Bullet.tscn")

@onready var _fire_rate: Timer = $FireRate

signal shoot_bullet

func _physics_process(_delta: float) -> void:
	var movement = Vector2.ZERO
	var mouse_pos: Vector2 = get_global_mouse_position()
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	velocity = movement * SPEED
	rotation = global_position.direction_to(mouse_pos).angle()
	
	if Input.is_action_pressed("ui_left_click") and _fire_rate.is_stopped():
		var inst: Bullet = BULLET.instantiate()
		var start_pos: Vector2 = global_position
		var direction: Vector2 = start_pos.direction_to(mouse_pos)
		get_owner().add_child(inst)
		inst.start(start_pos, direction)
		shoot_bullet.emit(inst)
		_fire_rate.start()
	
	move_and_slide()
