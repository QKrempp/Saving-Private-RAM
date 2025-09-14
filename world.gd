class_name World extends TileMapLayer

const WALL_ID=1
const CORNER_ID=2

const TOP := 2
const BOTTOM := 3
const RIGHT := 1
const LEFT := 0
const VOID := -1

enum VOISINS {
	HAUT	   = 1 << 0,  # 1
	HAUT_DROITE = 1 << 1, # 2
	DROITE	 = 1 << 2, # 4
	BAS_DROITE  = 1 << 3, # 8
	BAS		= 1 << 4,  # 16
	BAS_GAUCHE  = 1 << 5, # 32
	GAUCHE	 = 1 << 6, # 64
	HAUT_GAUCHE = 1 << 7, # 128
}

func calculer_masque_voisins(x: int, y: int, grille: Array) -> int:
	var masque = 0
	# Vérifie chaque voisin et met à jour le masque
	if x > 0 and grille[y][x-1] == 0:  # Gauche
		masque |= VOISINS.GAUCHE
	if x > 0 and y > 0 and grille[y-1][x-1] == 0:  # Haut-Gauche
		masque |= VOISINS.HAUT_GAUCHE
	if y > 0 and grille[y-1][x]:  # Haut
		masque |= VOISINS.HAUT
	if x < grille[0].size() - 1 and y > 0 and grille[y-1][x+1]:  # Haut-Droite
		masque |= VOISINS.HAUT_DROITE
	if x < grille[0].size() - 1 and grille[y][x+1]:  # Droite
		masque |= VOISINS.DROITE
	if x < grille[0].size() - 1 and y < grille.size() - 1 and grille[y+1][x+1]:  # Bas-Droite
		masque |= VOISINS.BAS_DROITE
	if y < grille.size() - 1 and grille[y+1][x]:  # Bas
		masque |= VOISINS.BAS
	if x > 0 and y < grille.size() - 1 and grille[y+1][x-1]:  # Bas-Gauche
		masque |= VOISINS.BAS_GAUCHE
	return masque


func render(grid: Array, x: int, y: int):
	if grid[y][x] == 1:
		var alt := compute_orientation(grid, x, y)
		if alt.x == 0:
			set_cell(Vector2(x, y), alt.x, Vector2(0, 0))
		else:
			set_cell(Vector2(x, y), alt.x, Vector2(0, 0), alt.y)

func compute_orientation(grid: Array, x: int, y: int) -> Vector2i:
	var res: Vector2i = Vector2i(0, 0)
	var top: int = 1
	var bottom: int = 1
	var left: int = 1
	var right: int = 1
	var top_right := 1
	var top_left := 1
	var bottom_right := 1
	var bottom_left := 1
	print(calculer_masque_voisins(x, y, grid))
	if y > 0:
		top = grid[y-1][x]
		if x > 0:
			top_left = grid[y-1][x-1]
		if x < grid[0].size()-1:
			top_right = grid[y-1][x+1]
	if y < grid.size()-1:
		bottom = grid[y+1][x]
		if x > 0:
			bottom_left = grid[y+1][x-1]
		if x < grid[0].size()-1:
			bottom_right = grid[y+1][x+1]
	if x > 0:
		left = grid[y][x-1]
	if x < grid[0].size()-1:
		right = grid[y][x+1]
	var total = top + bottom + left + right
	var total_diag = top_left + top_right + bottom_left + bottom_right
	if total == 4:
		res.x=4
		if top_left == 0:
			res.y=0
		elif top_right == 0:
			res.y=1
		elif bottom_right == 0:
			res.y=3
		elif bottom_left == 0:
			res.y=2
		else:
			res.x=0
		return res
	if total == 3: #simple walls
		res.x=1
		if top == 0:
			res.y = TOP
		if bottom == 0:
			res.y = BOTTOM
		if left == 0:
			res.y = LEFT
		if right == 0:
			res.y = RIGHT
	elif total == 2: #corner 2 empty neighbors
		res.x=randi_range(2, 3)
		if top == 0 and right == 0:
			res.y=1
		elif top == 0 and left == 0:
			res.y=0
		elif bottom == 0 and right == 0:
			res.y = 3
		elif bottom == 0 and left == 0:
			res.y=2
	elif total == 1:
		res.x=5
		if top == 1:
			res.y=1
		elif bottom == 1:
			res.y=0
		elif left == 1:
			res.y=3
		elif right == 1:
			res.y=2
	return res
	
	
