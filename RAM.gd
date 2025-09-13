class_name RamOverlay extends Label

@export var total_ram: int = 32
@export var ram_threshold_warning: float = 0.8
@export var default_text_color: Color = Color.WEB_GRAY
var used_ram: int = 0
var fps: int = 60

func _ready() -> void:
	add_theme_color_override("font_color", default_text_color)
	upate_overlay_text()
	
func _on_countable_entity_spawned(weight: int) -> void:
	used_ram += weight
	refresh_ram_counter()
	
func _on_countable_entity_destroyed(weight: int) -> void:
	used_ram -= weight
	refresh_ram_counter()

func refresh_ram_counter() -> void:
	var ram_pct: float = float(used_ram) / float(total_ram)
	if ram_pct > ram_threshold_warning:
		fps = int(60.0 * (1.0 - ram_pct) / (1.0 - ram_threshold_warning))
		add_theme_color_override("font_color", Color.RED)
	else:
		fps = 60
		add_theme_color_override("font_color", default_text_color)
	Engine.max_fps = fps
	if used_ram >= total_ram:
		get_tree().quit()
	upate_overlay_text()

func upate_overlay_text() -> void:
	text = "Available RAM: " + str(used_ram) + " / " + str(total_ram) + " Mo\nFPS: " + str(fps)
	
