class_name Bullet extends CountableEntity

const SPEED = 500

func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	rotation = direction.angle()
	velocity = direction * SPEED

func _physics_process(_delta: float) -> void:
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		entity_destroyed.emit()
		queue_free()
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	entity_destroyed.emit()
	queue_free()
