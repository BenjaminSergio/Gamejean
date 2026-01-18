extends Sprite2D


var data: ItemData = null
var is_picked: bool = false
var size: Vector2:
	get():
		return Vector2(data.dimensions.x, data.dimensions.y) * 16

var anchor_point: Vector2:
	get():
		return global_position - size / 2

func _ready() -> void:
	if data:
		texture = data.texture

func _process(delta: float) -> void:
	if is_picked:
		global_position = get_global_mouse_position()

func set_init_position(position: Vector2) -> void:
	global_position = position + size / 2
	anchor_point = global_position - size / 2

func get_picked_up() -> void:
	add_to_group("held_items")
	is_picked = true
	z_as_relative = false
	z_index = 10
	anchor_point = global_position - size / 2

func get_placed(pos: Vector2i) -> void:
	is_picked = false
	global_position = pos + Vector2i(size/2)
	z_index = 1
	z_as_relative = true
	anchor_point = global_position - size / 2
	remove_from_group("held_items")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if is_picked:
				do_roration()

func do_roration() -> void:
	data.is_rotated = !data.is_rotated
	data.dimensions = Vector2i(data.dimensions.y, data.dimensions.x)
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 90 if data.is_rotated else 0, 0.3)