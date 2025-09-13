extends Label

@onready var player: MainCharacter = $/root/Room/MainCharacter

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	text = "level " + str(player.player_lvl)
