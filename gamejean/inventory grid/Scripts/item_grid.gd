extends GridContainer

const SLOT_SIZE: int = 16
#@export var Inventory_Slot_scene: PackedScene
@export var dimensions: Vector2i 
var slot_data: Array = []
var held_item_intersects: bool = false


func _ready() -> void:
	# create_slots()
	self.columns = dimensions.x
	init_slot_data()

# func create_slots() -> void:
# 	self.columns = dimensions.x 
# 	for x in dimensions.x:
# 		for y in dimensions.y:
# 			var inventory_slot = Inventory_Slot_scene.instantiate()
# 			add_child(inventory_slot)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var held_item = get_tree().get_first_node_in_group("held_items")
			if !held_item:
				var index = get_slot_index_from_coords(get_global_mouse_position())
				var slot_index = get_slot_index_from_coords(get_global_mouse_position())
				var item = slot_data[slot_index]
				if !item:
					return 
				item.get_picked_up()
				remove_item_from_slot_data(item)
			else:
				if !held_item_intersects:
					return
				var offset = Vector2(SLOT_SIZE, SLOT_SIZE) / 2
				var index = get_slot_index_from_coords(held_item.anchor_point + offset)
				
				if !is_within_bounds(index, held_item.data):
					return
				
				var items = items_in_area(index, held_item.data)

				if items.size():
					if items.size() == 1:
						held_item.reparent(self)
						held_item.get_placed(get_coords_from_slot_index(index))
						remove_item_from_slot_data(items[0])
						add_item_to_slot_data(held_item, index)
						items[0].get_picked_up()
					return
				held_item.get_placed(get_coords_from_slot_index(index))
				add_item_to_slot_data(held_item, index)
	if event is InputEventMouseMotion:
		var held_item = get_tree().get_first_node_in_group("held_items")
		if held_item:
			detect_held_item_intersection(held_item)

func detect_held_item_intersection(held_item : Node) -> void:
	var h_rect = Rect2(held_item.anchor_point, held_item.size)
	var g_rect = Rect2(global_position, size)
	var inter = h_rect.intersection(g_rect).size
	held_item_intersects = (inter.x * inter.y) / (held_item.size.x * held_item.size.y) > 0.8


func remove_item_from_slot_data(item: Node) -> void:
	for i in slot_data.size():
		if slot_data[i] == item:
			slot_data[i] = null

func add_item_to_slot_data(item: Node, index: int) -> void:
	for x in item.data.dimensions.x:
		for y in item.data.dimensions.y:
			if item.data.is_solid(x, y):
				slot_data[index + x + y * columns] = item

func is_within_bounds(index: int, data: ItemData) -> bool:
	if index < 0 or index >= slot_data.size():
		return false

	for x in data.dimensions.x:
		for y in data.dimensions.y:
			if data and !data.is_solid(x, y):
				continue

			var curr_index = index + x + y * columns
			
			if curr_index >= slot_data.size():
				return false

			if (index + x) / columns != index / columns:
				return false
				
	return true

func items_in_area(index: int, item_data: ItemData) -> Array:
	var items: Dictionary = {}
	var item_dimensions = item_data.dimensions
	for y in item_dimensions.y:
		for x in item_dimensions.x:
			var slot_index = index + x + y * columns
			if slot_index < 0 or slot_index >= slot_data.size():
				continue
			if (index + x) / columns != index / columns:
				continue
			var item = slot_data[slot_index]
			if !item:
				continue
			if !items.has(item):
				items[item] = true
	return items.keys() if items.size() else []

func init_slot_data() -> void:
	var child_count = get_child_count()
	slot_data.resize(child_count)
	slot_data.fill(null)

	if child_count != slot_data.size():
			printerr("ERRO: O numero de slots manuais (" + str(child_count) + ") difere das dimensoes configuradas (" + str(slot_data.size()) + ")!")
	for i in range(child_count):
		var child = get_child(i)
		if "is_blocked" in child and child.is_blocked:
			slot_data[i] = "BLOCKED"

func attempt_to_add_item_data(item: Node) -> bool:
	var slot_index:int = 0
	while slot_index < slot_data.size():
		if item_fits(slot_index, item.data.dimensions,item.data):
			break
		slot_index += 1
	if slot_index >= slot_data.size():
		return false
	for x in item.data.dimensions.x:
		for y in item.data.dimensions.y:
			slot_data[slot_index + x + y * columns] = item

	item.set_init_position(get_coords_from_slot_index(slot_index))
	return true

func item_fits(index: int, dimensions: Vector2i, data: ItemData = null) -> bool:
	if index < 0 or index >= slot_data.size(): return false
	for x in dimensions.x:
		for y in dimensions.y:
			if data and !data.is_solid(x, y):
				continue
			var curr_index = index + x + y * columns
			if curr_index >= slot_data.size():
				return false
			if slot_data[curr_index] != null:
				return false
			var splitX = index / columns != (index + x) / columns

			if splitX:
				return false
	return true
func get_slot_index_from_coords(coords: Vector2i) -> int:
	coords -= Vector2i(self.global_position)
	coords = coords / SLOT_SIZE
	var index = coords.x + coords.y * columns
	if index > dimensions.x * dimensions.y || index < 0	:
		return -1
	return index

func get_coords_from_slot_index(index: int) -> Vector2i:
	var row = index / columns
	var column = index % columns
	return Vector2i(global_position) + Vector2i(column * SLOT_SIZE, row * SLOT_SIZE)
