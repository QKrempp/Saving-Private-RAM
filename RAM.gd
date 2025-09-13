class_name RamOverlay extends Label

const TOTAL_RAM: int = 1024
var used_ram: int = 0

func _ready() -> void:
	text = "Available RAM: " + str(used_ram) + " / " + str(TOTAL_RAM) + " Mo"

func _on_shoot_bullet(bullet: Bullet) -> void:
	bullet.entity_destroyed.connect(_on_countable_entity_destroyed.bind())
	_on_countable_entity_spawned()

func _on_enemy_spawned(enemy: Enemy) -> void:
	enemy.entity_destroyed.connect(_on_countable_entity_destroyed.bind())
	_on_countable_entity_spawned()

func _on_countable_entity_spawned() -> void:
	used_ram += 1
	refresh_ram_counter()
	
func _on_countable_entity_destroyed() -> void:
	used_ram -=1
	refresh_ram_counter()

func refresh_ram_counter() -> void:
	text = "Available RAM: " + str(used_ram) + " / " + str(TOTAL_RAM) + " Mo"
