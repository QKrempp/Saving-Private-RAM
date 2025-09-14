extends Sprite2D

@onready var _ram : RamOverlay = $/root/Room/Overlay/RAM
@onready var _room: Node2D = $/root/Room

@export var weight:float = 2.1

func _ready() -> void:
	_ram._on_countable_entity_spawned(weight)
	_room.clear_blood.connect(queue_free.bind())

func start(start_pos: Vector2, direction: Vector2) -> void:
	global_position = start_pos
	rotation = direction.angle()
	
func _exit_tree() -> void:
	_ram._on_countable_entity_destroyed(weight)
