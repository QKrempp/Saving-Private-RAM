class_name MainCharacter extends CountableEntity

const SPEED: int = 100
const BULLET: PackedScene = preload("res://Bullet.tscn")

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var bruits_de_pas: AudioStreamPlayer = $BruitsDePas
@onready var _fire_rate: Timer = $FireRate
@onready var	 animated_ryan_sprite:AnimatedSprite2D = $AnimatedSprite2D

var last_offset := 0.0
var _fade_tween: Tween # pour éviter les tweens qui se chevauchent

var player_xp = 0
var player_lvl = 0

signal shoot_bullet

func _kill_fade_tween():
	if _fade_tween and _fade_tween.is_running():
		_fade_tween.kill()
	_fade_tween = null

func fade_out(player: AudioStreamPlayer, duration: float = 0.2):
	_kill_fade_tween()
	_fade_tween = get_tree().create_tween()
	_fade_tween.tween_property(player, "volume_db", -80.0, duration)
	_fade_tween.tween_callback(func():
		# mémoriser la position juste avant d'arrêter
		last_offset = player.get_playback_position()
		player.stop()
		player.volume_db = 0.0 # reset pour la prochaine lecture
	)

func _safe_seek_from_last_offset(player: AudioStreamPlayer):
	var stream_len := 0.0
	if player.stream:
		stream_len = player.stream.get_length() # 0.0 si inconnu
	# Si on connaît la longueur, remet l'offset dans [0, len)
	if stream_len > 0.0:
		var pos := fposmod(last_offset, stream_len)
		player.seek(pos)
	else:
		player.seek(last_offset) # au pire, on tente

func _physics_process(_delta: float) -> void:
	var movement = Vector2.ZERO
	var mouse_pos: Vector2 = get_global_mouse_position()

	if Input.is_action_pressed("ui_left"):  movement.x -= 1
	if Input.is_action_pressed("ui_right"): movement.x += 1
	if Input.is_action_pressed("ui_up"):    movement.y -= 1
	if Input.is_action_pressed("ui_down"):  movement.y += 1

	velocity = movement * SPEED
	rotation = global_position.direction_to(mouse_pos).angle()

	if velocity != Vector2.ZERO:
		if not bruits_de_pas.playing:
			# si on repart pendant un fade, le stopper
			_kill_fade_tween()
			bruits_de_pas.volume_db = 0.0
			bruits_de_pas.play()
			_safe_seek_from_last_offset(bruits_de_pas)
		animated_ryan_sprite.play("Walk")
	else:
		if bruits_de_pas.playing:
			fade_out(bruits_de_pas, 0.2)
		animated_ryan_sprite.play("Idle")

	if Input.is_action_pressed("ui_left_click") and _fire_rate.is_stopped():
		var inst: Bullet = BULLET.instantiate()
		var start_pos: Vector2 = global_position
		var direction: Vector2 = start_pos.direction_to(mouse_pos)
		get_tree().current_scene.add_child(inst) # selon ta scène, get_parent() ou get_tree().current_scene peut être plus sûr
		inst.start(start_pos, direction)
		shoot_bullet.emit(inst)
		_fire_rate.start()
		audio.play()

	move_and_slide()
	
func _on_enemy_killed(entity_xp_amount: int) -> void:
	player_xp += entity_xp_amount
	if player_xp >= 100:
		player_xp = player_xp % 100
		player_lvl += 1
	print("Xp: " + str(player_xp))
