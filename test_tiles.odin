package macropolis

import "core:testing"
import "core:fmt"


@(test)
resource_type_should_be_subset_of_tile_type :: proc(t: ^testing.T) {
    for i in 0 ..< len(ResourceType) {
        r_name := fmt.tprintf("%v", ResourceType(i))

        found := false
        for j in 0 ..< len(TileType) {
            t_name := fmt.tprintf("%v", TileType(j))
            if r_name == t_name {
                found = true
                break
            }
        }

        testing.expect_value(t, found, true)
    }
}


build_type_should_be_subset_of_tile_type :: proc(t: ^testing.T) {
    for i in 0 ..< len(BuildType) {
        b_name := fmt.tprintf("%v", BuildType(i))

        found := false
        for j in 0 ..< len(TileType) {
            t_name := fmt.tprintf("%v", TileType(j))
            if b_name == t_name {
                found = true
                break
            }
        }

        testing.expect_value(t, found, true)
    }
}

