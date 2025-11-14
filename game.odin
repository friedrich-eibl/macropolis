package macropolis

import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"


GameState :: struct {
	tiles: [GRID_W][GRID_H]Tile,
	available_types: [8]BuildOption,
	selected_type: TileType,
}


draw_grid :: proc () {
	rlgl.PushMatrix()
	rlgl.Translatef(0, 25 * 50, 0)
	rlgl.Rotatef(90, 1, 0, 0)
    	rl.DrawGrid(100, 50)
	rlgl.PopMatrix()
}


init_game :: proc (state: ^GameState) {
	for x in 0 ..< GRID_W {
		for y in 0 ..< GRID_H {
			state.tiles[x][y].type = .Empty
		}
	}
	
	state.available_types[0] = BuildOption{type = .Road, name = "Road"}
	state.available_types[1] = BuildOption{type = .House, name = "House"}
	state.selected_type = .Empty
}


update_game :: proc (state: ^GameState) {
	if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		mouse := rl.GetMousePosition()

		x := i32(mouse.x) / T_SIZE
		y := i32(mouse.y) / T_SIZE

		if x >= 0 && x < GRID_W && y >= 0 && y < GRID_H {
			tile := &state.tiles[x][y]
			tile.type = state.selected_type
		}
	}
}


draw_game :: proc (state: ^GameState, textures_p: ^TileTextures) {
	for x in 0 ..< GRID_W {
		for y in 0 ..< GRID_H {
	        	tile := state.tiles[x][y]
			
			texture := get_tile_texture(tile.type, textures_p)

	           	x_px : i32 = x * T_SIZE
	           	y_px : i32 = y * T_SIZE
	  		 
			rl.DrawTextureEx(texture, {f32(x_px), f32(y_px)}, 0, 0.048, rl.WHITE)
	           	rl.DrawRectangleLines(x_px, y_px, T_SIZE, T_SIZE, rl.BLACK)
		}
	}
}

