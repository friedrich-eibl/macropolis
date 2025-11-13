package macropolis

import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"


GRID_W :: 256
GRID_H :: 256
T_SIZE :: 48


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


draw_game :: proc () {

}


main :: proc () {
    	rl.InitWindow(800, 450, "Macropolis")
	position : rl.Vector3 = {0.0, 0.0, 0.0}
	
	camera : rl.Camera2D = {}
	camera.zoom = 1.0

	rl.SetTargetFPS(60)
	state : GameState = {}
	init_game(&state)
	
	for !rl.WindowShouldClose() {
		// rl.UpdateCamera(&camera, .FIRST_PERSON);
        	rl.BeginDrawing()
            	rl.ClearBackground(rl.RAYWHITE)
		
		rl.BeginMode2D(camera)
		draw_grid()
		rl.EndMode2D()
        
		rl.EndDrawing()
    	}

    	rl.CloseWindow()
}
