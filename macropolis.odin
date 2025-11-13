package macropolis

import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"


GRID_W : i32 : 256
GRID_H : i32 : 256
T_SIZE : i32 : 48


TileType :: enum {
	Empty,
	Wood,
	Stone,
	Iron,
	Gold,
	House,
	Road,
}


Tile :: struct {
	type : TileType,
}


GameState :: struct {
	tiles: [GRID_W][GRID_H]Tile,
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
}


update_game :: proc (state: ^GameState) {
	if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		mouse := rl.GetMousePosition()

		x := i32(mouse.x) / T_SIZE
		y := i32(mouse.y) / T_SIZE

		if x >= 0 && x < GRID_W && y >= 0 && y < GRID_H {
			tile := &state.tiles[x][y]
			tile.type = .Gold
		}
	}
}


draw_game :: proc (state: ^GameState) {
	for x in 0 ..< GRID_W {
		for y in 0 ..< GRID_H {
	        	tile := state.tiles[x][y]
			color : rl.Color
	            	switch tile.type {
	        	    	case .Empty:
					color = rl.Color{30, 30, 30, 255}
	        	    	case .Wood:
					color = rl.Color{34, 139, 34, 255}
	        	    	case .Stone:
					color = rl.Color{120, 120, 120, 255}
				case .Iron:
					color = rl.Color{166, 166, 166, 255}
				case .Gold:
					color = rl.Color{184, 148, 4, 255}
	        	    	case .House:
	        	        	color = rl.Color{200, 180, 80, 255}
	        	    	case .Road:
	        	        	color = rl.Color{80, 80, 80, 255}
	            	}
	
	           	x_px : i32 = x * T_SIZE;
	           	y_px : i32 = y * T_SIZE;
	
	           	 
	           	rl.DrawRectangle(x_px, y_px, T_SIZE, T_SIZE, color);
	           	rl.DrawRectangleLines(x_px, y_px, T_SIZE, T_SIZE, rl.BLACK);
		}
	}
}


main :: proc () {
    	rl.InitWindow(800, 450, "Macropolis")
	position : rl.Vector3 = {0.0, 0.0, 0.0}
	
	camera : rl.Camera2D = {}
	camera.zoom = 1.0

	rl.SetTargetFPS(60)
	state_p := new(GameState)
	init_game(state_p)
	
	for !rl.WindowShouldClose() {
		update_game(state_p)

        	rl.BeginDrawing()
            	rl.ClearBackground(rl.RAYWHITE)
		
		rl.BeginMode2D(camera)
		draw_grid()
		draw_game(state_p)
		rl.EndMode2D()
        
		rl.EndDrawing()
    	}

    	rl.CloseWindow()
	free(state_p)
}
