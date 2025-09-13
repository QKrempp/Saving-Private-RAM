class_name Ennemy extends CountableEntity

const SPEED = 50
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


func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	rotation = direction.angle()
	velocity = direction * SPEED
	
