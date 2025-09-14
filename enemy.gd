class_name Enemy extends CountableEntity

const SPEED = 50
var health = 2
var xp_amount = 5

const BLOOD_SPLATTER = preload("res://BloodSplatter.tscn")

@onready var _animated_zombie1_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var _timer: Timer = $Wander

var target: Node2D = null

func _physics_process(_delta: float) -> void:
	
	if target:
		velocity = SPEED * global_position.direction_to(target.global_position)
		rotation = velocity.angle()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision and collision.get_collider() and collision.get_collider().is_in_group("bullets"):
			var bullet = collision.get_collider()
			hit(bullet)
			bullet.entity_destroyed.emit()
			bullet.queue_free()

	if velocity != Vector2.ZERO:
		_animated_zombie1_sprite.play("WalkZombie1")
	else:
		_animated_zombie1_sprite.play("IdleZombie1")
	move_and_slide()

func hit(bullet: Bullet) -> void:
	health -= 1
	var inst: BloodSplatter = BLOOD_SPLATTER.instantiate()
	inst.blood_splattered.connect(_ram._on_countable_entity_spawned.bind(1))
	inst.start(global_position, bullet.rotation)
	get_tree().current_scene.add_child(inst)
	if health <= 0:
		#entity_destroyed.emit()
		queue_free()


func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	rotation = direction.angle()
	velocity = direction * SPEED


func _on_smell_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body


func _on_wander_timeout() -> void:
	print("Time is up!")
	if not target:
		print("No target yet")
		var angle = randf_range(0, 2 * PI)
		velocity = SPEED * Vector2.from_angle(angle)
		rotation = angle
		_timer.wait_time = 1.0 + 2.0 * randf()
	
