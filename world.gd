class_name World extends TileMapLayer

var map_sprite = {
	0: Vector2i(0, 0),
	
	#Mur1Droit
	#- left
	8: Vector2i(1, 0),
	9: Vector2i(1, 0),
	40: Vector2i(1, 0),
	41: Vector2i(1, 0),
	#- right
	16: Vector2i(1, 1),
	20: Vector2i(1, 1),
	144: Vector2i(1, 1),
	148: Vector2i(1, 1),
	#- top
	2: Vector2i(1, 2),
	3: Vector2i(1, 2),
	6: Vector2i(1, 2),
	7: Vector2i(1, 2),
	#- bottom
	64: Vector2i(1, 3),
	96: Vector2i(1, 3),
	192: Vector2i(1, 3),
	224: Vector2i(1, 3),
	
	#Mur1Angle and Mur1AngleOblique
	#- top left
	10: Vector2i(2, 0),
	11: Vector2i(2, 0),
	14: Vector2i(2, 0),
	15: Vector2i(2, 0),
	42: Vector2i(2, 0),
	43: Vector2i(2, 0),
	46: Vector2i(2, 0),
	47: Vector2i(2, 0),
	#- top right
	18: Vector2i(2, 1),
	19: Vector2i(2, 1),
	22: Vector2i(2, 1),
	23: Vector2i(2, 1),
	146: Vector2i(2, 1),
	147: Vector2i(2, 1),
	150: Vector2i(2, 1),
	151: Vector2i(2, 1),
	#- bottom left
	72: Vector2i(2, 2),
	73: Vector2i(2, 2),
	104: Vector2i(2, 2),
	105: Vector2i(2, 2),
	200: Vector2i(2, 2),
	201: Vector2i(2, 2),
	232: Vector2i(2, 2),
	233: Vector2i(2, 2),
	#- bottom right
	80: Vector2i(2, 3),
	84: Vector2i(2, 3),
	112: Vector2i(2, 3),
	116: Vector2i(2, 3),
	208: Vector2i(2, 3),
	212: Vector2i(2, 3),
	240: Vector2i(2, 3),
	244: Vector2i(2, 3),
	
	
	#Mur1PetitAngle
	1: Vector2i(4, 0),
	4: Vector2i(4, 1),
	32: Vector2i(4, 2),
	128: Vector2i(4, 3),
	
	#Mur1DoubleExtremite
	#- top
	26: Vector2i(5, 0),
	27: Vector2i(5, 0),
	30: Vector2i(5, 0),
	31: Vector2i(5, 0),
	58: Vector2i(5, 0),
	59: Vector2i(5, 0),
	63: Vector2i(5, 0),
	154: Vector2i(5, 0),
	186: Vector2i(5, 0),
	158: Vector2i(5, 0),
	159: Vector2i(5, 0),
	187: Vector2i(5, 0),
	190: Vector2i(5, 0),
	191: Vector2i(5, 0),
	#- bottom
	88: Vector2i(5, 1),
	92: Vector2i(5, 1),
	93: Vector2i(5, 1),
	120: Vector2i(5, 1),
	216: Vector2i(5, 1),
	221: Vector2i(5, 1),
	248: Vector2i(5, 1),
	249: Vector2i(5, 1),
	252: Vector2i(5, 1),
	253: Vector2i(5, 1),
	#- left
	74: Vector2i(5, 2),
	75: Vector2i(5, 2),
	106: Vector2i(5, 2),
	107: Vector2i(5, 2),
	#- right
	82: Vector2i(5, 0),
	86: Vector2i(5, 0),
	210: Vector2i(5, 0),
	214: Vector2i(5, 0),
	
	#Mur1Double
	#vert
	24: Vector2i(6, 0),
	25: Vector2i(6, 0),
	29: Vector2i(6, 0),
	57: Vector2i(6, 0),
	60: Vector2i(6, 0),
	61: Vector2i(6, 0),
	153: Vector2i(6, 0),
	156: Vector2i(6, 0),
	184: Vector2i(6, 0),
	185: Vector2i(6, 0),
	188: Vector2i(6, 0),
	189: Vector2i(6, 0),
	#horiz
	66: Vector2i(6, 1),
	67: Vector2i(6, 1),
	71: Vector2i(6, 1),
	99: Vector2i(6, 1),
	102: Vector2i(6, 1),
	103: Vector2i(6, 1),
	195: Vector2i(6, 1),
	198: Vector2i(6, 1),
	199: Vector2i(6, 1),
	226: Vector2i(6, 1),
	227: Vector2i(6, 1),
	230: Vector2i(6, 1),
	231: Vector2i(6, 1),
}

func booleens_vers_entier(booleens: Array) -> int:
	var masque = 0
	for i in range(booleens.size()):
		if booleens[i]:
			masque |= 1 << i
	return masque

func render(grid: Array, x: int, y: int):
	if grid[y][x] == 1:
		var alt := compute_orientation(grid, x, y)
		if alt.x == 2:
			alt.x = randi_range(2, 3)
		set_cell(Vector2(x, y), alt.x, Vector2(0, 0), alt.y)

func compute_orientation(grid: Array, x: int, y: int) -> Vector2i:
	var res: Vector2i = Vector2i(0, 0)
	var top := false
	var bottom := false
	var left := false
	var right := false
	var top_right := false
	var top_left := false
	var bottom_right := false
	var bottom_left := false
	if x > 0 and grid[y][x-1] == 0:  # Gauche
		left = true
	if x > 0 and y > 0 and grid[y-1][x-1] == 0:  # Haut-Gauche
		top_left = true
	if y > 0 and grid[y-1][x] == 0:  # Haut
		top = true
	if x < grid[0].size() - 1 and y > 0 and grid[y-1][x+1] == 0:  # Haut-Droite
		top_right = true
	if x < grid[0].size() - 1 and grid[y][x+1] == 0:  # Droite
		right = true
	if x < grid[0].size() - 1 and y < grid.size() - 1 and grid[y+1][x+1] == 0:  # Bas-Droite
		bottom_right = true
	if y < grid.size() - 1 and grid[y+1][x] == 0:  # Bas
		bottom = true
	if x > 0 and y < grid.size() - 1 and grid[y+1][x-1] == 0:  # Bas-Gauche
		bottom_left = true
	var neighbors = [top_left, top, top_right, left, right, bottom_left, bottom, bottom_right]
	var key = booleens_vers_entier(neighbors)
	if key == 2:
		print("resume")
		print(neighbors)
		print(key)
		print(map_sprite.get(key, Vector2i(0, 0)))
	return map_sprite.get(key, Vector2i(0, 0))
	
