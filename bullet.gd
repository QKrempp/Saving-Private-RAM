class_name Bullet extends CountableEntity

const SPEED = 2000

func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	rotation = direction.angle()
	velocity = direction * SPEED

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	entity_destroyed.emit()
	queue_free()
