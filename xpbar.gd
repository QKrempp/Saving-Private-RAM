extends ProgressBar


@onready var player: MainCharacter = $/root/Room/MainCharacter

func _ready():
	max_value = player.xp_cap
	value = player.player_xp

func _process(_delta):
	max_value = player.xp_cap
	value = player.player_xp
