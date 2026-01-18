class_name ItemData extends Resource

@export var name: String
@export var texture: Texture2D
@export var dimensions: Vector2i
@export var grid_pattern: Array[bool] = []

var is_rotated: bool = false

func is_solid(x: int, y: int) -> bool:
    if grid_pattern.is_empty():
        return true
    var index = y * dimensions.x + x
    if index < 0 or index >= grid_pattern.size():
        return false
    return grid_pattern[index]