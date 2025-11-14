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


TileTextures :: [len(TileType)]rl.Texture2D


BuildOption :: struct {
	type: TileType,
	name: cstring,
}


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


load_textures :: proc(textures_p: ^TileTextures) {
	textures_p^[TileType.Empty] = rl.LoadTexture("assets/grass.png")
	textures_p^[TileType.Wood] = rl.LoadTexture("assets/wood.png")
	textures_p^[TileType.Stone] = rl.LoadTexture("assets/stone.png")
	textures_p^[TileType.Iron] = rl.LoadTexture("assets/iron.png")
	textures_p^[TileType.Gold] = rl.LoadTexture("assets/gold.png")
	textures_p^[TileType.House] = rl.LoadTexture("assets/house.png")
	textures_p^[TileType.Road] = rl.LoadTexture("assets/road.png")
}


get_tile_color :: proc(type: TileType) -> rl.Color {
	color : rl.Color
	switch type {
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
	return color
}


get_tile_texture :: proc(type: TileType, textures_p: ^TileTextures) -> rl.Texture2D {
	return textures_p^[type]
}


draw_game :: proc (state: ^GameState, textures_p: ^TileTextures) {
	for x in 0 ..< GRID_W {
		for y in 0 ..< GRID_H {
	        	tile := state.tiles[x][y]
			
			texture := get_tile_texture(tile.type, textures_p)

	           	x_px : i32 = x * T_SIZE
	           	y_px : i32 = y * T_SIZE
	  		 
			rl.DrawTextureEx(texture, {f32(x_px), f32(y_px)}, 0, 0.048, rl.WHITE)
	           	rl.DrawRectangleLines(x_px, y_px, T_SIZE, T_SIZE, rl.BLACK);
		}
	}
}


update_build_menu :: proc(state: ^GameState) {
	if !rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		return
	}

	mouse_pos := rl.GetMousePosition()
	ui_x := 8;
    	ui_y := 8;
    	tile_size := 24;
    	spacing_y := 6;

        for i in 0..<len(state.available_types) {
            opt := state.available_types[i]

            y := ui_y + i * (tile_size + spacing_y)

            // bounds of this menu entry (just around the tile + text)
            min_x := f32(ui_x);
            max_x := min_x + 200;  // wide enough for tile + text
            min_y := f32(y);
            max_y := min_y + f32(tile_size);

            if mouse_pos.x >= min_x && mouse_pos.x <= max_x &&
               mouse_pos.y >= min_y && mouse_pos.y <= max_y {
                state.selected_type = opt.type
                return; // done
            }
        }

}


draw_build_menu :: proc(state: ^GameState) {
    	ui_x : i32 = 8
    	ui_y : i32 = 8

    	tile_size   : i32 = 24
    	font_size   : i32 = 20
    	spacing_y   : i32 = 6

    	for i in 0 ..< 2 {
    	    	opt := state.available_types[i]
    	    	y := ui_y + i32(i) * (tile_size + spacing_y)

    	    	color := get_tile_color(opt.type)

    	    	rl.DrawRectangle(
    	    	    ui_x,
    	    	    y,
    	    	    tile_size,
    	    	    tile_size,
    	    	    color
    	    	);

    	    	rl.DrawText(
    	    	    opt.name,
    	    	    ui_x + tile_size + 8,
    	    	    y + (tile_size - font_size) / 2,
    	    	    font_size,
    	    	    rl.RAYWHITE
    	    	);
    	}
}


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
		draw_grid()
		draw_game(state_p, textures_p)
		draw_build_menu(state_p)
		rl.EndMode2D()
        
		rl.EndDrawing()
    	}

    	rl.CloseWindow()
	free(state_p)
}
