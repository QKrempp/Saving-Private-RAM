class_name RamOverlay extends Label

const TOTAL_RAM: int = 32
var used_ram: int = 0

func _ready() -> void:
	add_theme_color_override("font_color", Color.WHITE)
	text = "Available RAM: " + str(used_ram) + " / " + str(TOTAL_RAM) + " Mo"

func _on_countable_entity_spawned() -> void:
	used_ram += 1
	refresh_ram_counter()
	
func _on_countable_entity_destroyed() -> void:
	used_ram -=1
	refresh_ram_counter()

func refresh_ram_counter() -> void:
	text = "Available RAM: " + str(used_ram) + " / " + str(TOTAL_RAM) + " Mo"
	if float(used_ram) / float(TOTAL_RAM) > 0.8:
		add_theme_color_override("font_color", Color.RED)
	if used_ram >= TOTAL_RAM:
		get_tree().quit()
