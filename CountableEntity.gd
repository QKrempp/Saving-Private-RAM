class_name CountableEntity extends CharacterBody2D

signal entity_created
signal entity_destroyed

func _ready() -> void:
	entity_created.emit()
