class_name Floor extends TileMapLayer

func render(grid: Array, x: int, y: int):
	set_cell(Vector2(x, y), randi_range(1, 2), Vector2(0, 0))
