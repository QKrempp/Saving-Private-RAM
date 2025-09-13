class_name Enemy extends CountableEntity

const SPEED = 50
var health = 2
var xp_amount = 5

@onready var	 animated_zombie1_sprite:AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision and collision.get_collider() and collision.get_collider().is_in_group("bullets"):
				hit()

	if velocity != Vector2.ZERO:
		animated_zombie1_sprite.play("WalkZombie1")
	else:
		animated_zombie1_sprite.play("IdleZombie1")
	move_and_slide()
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
