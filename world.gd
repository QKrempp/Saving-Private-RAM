class_name World extends TileMapLayer

const WALL_ID=1
const CORNER_ID=2

const TOP := 2
const BOTTOM := 3
const RIGHT := 1
const LEFT := 0
const VOID := -1


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
	if total == 4:
		if top_left == 0:
			res.x=4
			res.y=0
		elif top_right == 0:
			res.x=4
			res.y=1
		elif bottom_right == 0:
			res.x=4
			res.y=3
		elif bottom_left == 0:
			res.x=4
			res.y=2
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
	return res
	
	
