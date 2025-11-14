package macropolis

import rl "vendor:raylib"


BuildOption :: struct {
	type: TileType,
	name: cstring,
}


update_build_menu :: proc(state: ^GameState) {
	if !rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		return
	}

	mouse_pos := rl.GetMousePosition()
	ui_x := 8
    	ui_y := 8
    	tile_size := 24
    	spacing_y := 6

        for i in 0..<len(state.available_types) {
            opt := state.available_types[i]

            y := ui_y + i * (tile_size + spacing_y)

            // bounds of this menu entry (just around the tile + text)
            min_x := f32(ui_x)
            max_x := min_x + 200  // wide enough for tile + text
            min_y := f32(y)
            max_y := min_y + f32(tile_size)

            if mouse_pos.x >= min_x && mouse_pos.x <= max_x &&
               mouse_pos.y >= min_y && mouse_pos.y <= max_y {
                state.selected_type = opt.type
                return // done
            }
        }

}


draw_build_menu :: proc(state: ^GameState, textures_p: ^TileTextures) {
    	ui_x : i32 = 8
    	ui_y : i32 = 8

    	tile_size   : i32 = 24
    	font_size   : i32 = 20
    	spacing_y   : i32 = 6

    	for i in 0 ..< 2 {
    	    	opt := state.available_types[i]
    	    	y := ui_y + i32(i) * (tile_size + spacing_y)

    	    	texture := get_tile_texture(opt.type, textures_p)

		rl.DrawTextureEx(
			texture, 
			{f32(ui_x), f32(y)}, 
			0, 
			0.024, 
			rl.WHITE
		)

    	    	rl.DrawText(
    	    		opt.name,
    	    		ui_x + tile_size + 8,
    	    		y + (tile_size - font_size) / 2,
    	    		font_size,
			rl.RAYWHITE
    	    	)
    	}
}

