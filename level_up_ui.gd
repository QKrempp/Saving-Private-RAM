extends CanvasLayer

signal option_chosen(upgrade_id: String)

@onready var panel: Panel = $Panel
@onready var btn_a: Button = $"Panel/Premier-upgrade"
@onready var btn_b: Button = $"Panel/Deuxieme-upgrade"

var _opt_a: Dictionary = {}
var _opt_b: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	btn_a.pressed.connect(_on_btn_a)
	btn_b.pressed.connect(_on_btn_b)
	hide_ui()

func show_two_options(opt_a: Dictionary, opt_b: Dictionary) -> void:
	_opt_a = opt_a
	_opt_b = opt_b
	btn_a.icon = load("res://Art/Upgrades/" + _opt_a.get("id", "") +  ".png")
	btn_b.icon = load("res://Art/Upgrades/" + _opt_b.get("id", "") +  ".png")
	panel.visible = true

func hide_ui() -> void:
	panel.visible = false

func _on_btn_a() -> void:
	emit_signal("option_chosen", _opt_a.get("id", ""))

func _on_btn_b() -> void:
	emit_signal("option_chosen", _opt_b.get("id", ""))
