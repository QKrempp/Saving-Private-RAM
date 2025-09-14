class_name BloodSplatter extends Sprite2D

signal blood_splattered

func start(start_pos: Vector2, orientation: float) -> void:
	global_position = start_pos + 50 * Vector2.from_angle(orientation)
	rotation = orientation + (PI * 3/4)
	#blood_splattered.emit()


func _on_timer_timeout() -> void:
	queue_free()
