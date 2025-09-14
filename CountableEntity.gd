class_name CountableEntity extends CharacterBody2D

signal entity_created
signal entity_destroyed

@onready var _ram : RamOverlay = $/root/Room/Overlay/RAM

@export var weight: int  = 1

func _ready() -> void:
	_ram._on_countable_entity_spawned(weight)
	
func _exit_tree() -> void:
	_ram._on_countable_entity_destroyed(weight)
