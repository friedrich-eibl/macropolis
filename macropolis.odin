package macropolis

import rl "vendor:raylib"


GRID_W : i32 : 256
GRID_H : i32 : 256
T_SIZE : i32 : 48


main :: proc () {
	rl.InitWindow(800, 450, "Macropolis")
	// rl.InitWindow(1280, 720, "Macropolis")
	// rl.ToggleFullscreen();

	position : rl.Vector3 = {0.0, 0.0, 0.0}
	
	camera : rl.Camera2D = {}
	camera.zoom = 1.0

	rl.SetTargetFPS(60)
	textures_p := new(TileTextures)
	load_textures(textures_p)
	state_p := new(GameState)
	init_game(state_p)
	
	for !rl.WindowShouldClose() {
		update_build_menu(state_p)
		update_game(state_p)

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		
		rl.BeginMode2D(camera)
		// draw_grid()
		draw_game(state_p, textures_p)
		draw_build_menu(state_p, textures_p)
		rl.EndMode2D()
        
		rl.EndDrawing()
    	}

    	rl.CloseWindow()
	free(state_p)
}
