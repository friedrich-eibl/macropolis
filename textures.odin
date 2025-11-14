package macropolis

import rl "vendor:raylib"


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


load_textures :: proc(textures_p: ^TileTextures) {
	textures_p^[TileType.Empty] = rl.LoadTexture("assets/grass.png")
	textures_p^[TileType.Wood] = rl.LoadTexture("assets/wood.png")
	textures_p^[TileType.Stone] = rl.LoadTexture("assets/stone.png")
	textures_p^[TileType.Iron] = rl.LoadTexture("assets/iron.png")
	textures_p^[TileType.Gold] = rl.LoadTexture("assets/gold.png")
	textures_p^[TileType.House] = rl.LoadTexture("assets/house.png")
	textures_p^[TileType.Road] = rl.LoadTexture("assets/road.png")
}


get_tile_texture :: proc(type: TileType, textures_p: ^TileTextures) -> rl.Texture2D {
	return textures_p^[type]
}

