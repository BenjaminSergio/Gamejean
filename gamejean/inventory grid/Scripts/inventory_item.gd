extends Sprite2D


var data: ItemData = null
var is_picked: bool = false
var sentado: bool = false
var size: Vector2:
	get():
		return Vector2(data.dimensions.x, data.dimensions.y) * 16

var anchor_point: Vector2:
	get():
		return global_position - size / 2

func _ready() -> void:
	if data:
		data = data.duplicate(true)
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
	if data.grid_pattern.is_empty():
		data.dimensions = Vector2i(data.dimensions.y, data.dimensions.x)
	else:
		var old_width = data.dimensions.x
		var old_height = data.dimensions.y

		var new_pattern: Array[bool] = []
		new_pattern.resize(old_height * old_width)
		new_pattern.fill(false)

		for y in range(old_height):
			for x in range(old_width):
				var old_index = x + y * old_width
				var is_solid = data.grid_pattern[old_index]
				var new_x = (old_height - 1) - y
				var new_y = x

				var new_width = old_height

				var new_index = new_y * new_width + new_x
				new_pattern[new_index] = is_solid
		data.grid_pattern = new_pattern
		data.dimensions = Vector2i(old_height, old_width)
	data.is_rotated = !data.is_rotated
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_degrees + 90,0.3)

func travar_no_assento() -> void:
	sentado = true
	modulate = Color(0.5, 0.5, 0.5, 1)