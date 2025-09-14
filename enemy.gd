class_name Enemy extends CountableEntity

const SPEED = 50
var health = 2
var xp_amount = 5

const BLOOD_SPLATTER = preload("res://BloodSplatter.tscn")

@onready var animated_zombie1_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var blood_particles = $BloodParticles
#@onready var _ram : RamOverlay = $/root/Room/Overlay/RAM

func _physics_process(_delta: float) -> void:
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision and collision.get_collider() and collision.get_collider().is_in_group("bullets"):
			var bullet = collision.get_collider()
			hit(bullet)
			bullet.entity_destroyed.emit()
			bullet.queue_free()

	if velocity != Vector2.ZERO:
		animated_zombie1_sprite.play("WalkZombie1")
	else:
		animated_zombie1_sprite.play("IdleZombie1")
	move_and_slide()

func hit(bullet: Bullet) -> void:
	health -= 1
	blood_particles.restart()
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
