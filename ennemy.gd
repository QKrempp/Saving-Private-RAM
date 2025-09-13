extends CountableEntity

var health = 10

func _physics_process(_delta: float) -> void:
	var collision = get_last_slide_collision()
	if collision and collision.get_collider().is_in_group("bullets"):
		hit()
	move_and_slide()

func hit() -> void:
	health -= 1
	if not health:
		entity_destroyed.emit()
		queue_free()
