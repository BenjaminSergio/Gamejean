extends GridContainer

const SLOT_SIZE: int = 16
#@export var Inventory_Slot_scene: PackedScene
@export var dimensions: Vector2i 
var slot_data: Array = []
var held_item_intersects: bool = false
var highlighted_slots: Array[Node] = []

@export var e_o_grid_do_onibus: bool = false
@export var scene_item: PackedScene

func _ready() -> void:
	self.columns = dimensions.x
	init_slot_data()
	mouse_exited.connect(clear_highlights)

	if e_o_grid_do_onibus:
		await get_tree().process_frame
		#Opcional: Carregar os dados do Global aqui, para já aparecerem os alunos no ponto de ônibus se voltar da cena do covil
		#carregar_dados_do_global()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var held_item = get_tree().get_first_node_in_group("held_items")
			
			# LÓGICA DE PEGAR (Mantém igual)
			if !held_item:
				var slot_index = get_slot_index_from_coords(get_global_mouse_position())
				var item = slot_data[slot_index]
				if !item: return 
				if "sentado" in item and item.sentado: return
				
				item.get_picked_up()
				remove_item_from_slot_data(item)

			else:
				if !held_item_intersects: return

				clear_highlights()
				
				var offset = Vector2(SLOT_SIZE, SLOT_SIZE) / 2
				var index = get_slot_index_from_coords(held_item.anchor_point + offset)
				
				if !is_within_bounds(index, held_item.data): return
				var items = items_in_area(index, held_item.data)

				if items.size()>0: return
				
				if not item_fits(index, held_item.data.dimensions, held_item.data):
					return # Se não couber (por qualquer motivo), cancela o drop
				
				# -----------------------------------------------------------------
				
				# Se passou no item_fits, pode colocar:
				held_item.reparent(self)
				held_item.get_placed(get_coords_from_slot_index(index))
				add_item_to_slot_data(held_item, index)

	if event is InputEventMouseMotion:
		var held_item = get_tree().get_first_node_in_group("held_items")
		if held_item:
			detect_held_item_intersection(held_item)
			highlight_preview(held_item)

func clear_highlights() -> void:
	for slot in highlighted_slots:
		if "is_blocked" in slot and slot.is_blocked:
			slot.modulate = Color(0, 0, 0, 0) 
		else:
			slot.modulate = Color.WHITE 
			
	highlighted_slots.clear()

func highlight_preview(held_item: Node) -> void:
	clear_highlights()
	
	# Calcula onde o "canto superior esquerdo" do item estaria
	var offset = Vector2(SLOT_SIZE, SLOT_SIZE) / 2
	var index = get_slot_index_from_coords(held_item.anchor_point + offset)
	
	# Se o mouse estiver muito fora do grid, nem desenha
	if index == -1: return

	var item_dim = held_item.data.dimensions
	
	# Itera sobre cada pedaço do item (respeitando a forma real)
	for x in item_dim.x:
		for y in item_dim.y:
			
			# Se o item tiver um "buraco" aqui (formato em L ou U), não pinta o slot
			if !held_item.data.is_solid(x, y):
				continue
				
			var slot_index = index + x + y * columns
			
			if slot_index < 0 or slot_index >= slot_data.size():
				continue

			if slot_index >= get_child_count():
				continue

			# Verifica se o slot existe
			if slot_index >= 0 and slot_index < get_child_count():
				# Verifica se não quebrou a linha (wrap around)
				if (index + x) / columns != index / columns:
					continue
				
				var slot_visual = get_child(slot_index)
				
				var is_occupied = slot_data[slot_index] != null
				
				if is_occupied:
					slot_visual.modulate = Color(1, 0, 0, 0.5) # Vermelho meio transparente
				else:
					slot_visual.modulate = Color(0, 1, 0, 0.5) # Verde meio transparente
				
				highlighted_slots.append(slot_visual)


func detect_held_item_intersection(held_item : Node) -> void:
	var h_rect = Rect2(held_item.anchor_point, held_item.size)
	var g_rect = Rect2(global_position, size)
	var inter = h_rect.intersection(g_rect).size
	held_item_intersects = (inter.x * inter.y) / (held_item.size.x * held_item.size.y) > 0.8


func remove_item_from_slot_data(item: Node) -> void:
	if not is_instance_valid(item):
		return # Se for um item fantasma, ignora
	for i in slot_data.size():
		var slot_valor = slot_data[i]
		if not (slot_valor is Node):
			continue
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
				
			var slot_visual = get_child(curr_index)

			if "is_blocked" in slot_visual and slot_visual.is_blocked:
				return false
				
	return true

func items_in_area(index: int, item_data: ItemData) -> Array:
	var items: Dictionary = {}
	var item_dimensions = item_data.dimensions
	for y in item_dimensions.y:
		for x in item_dimensions.x:

			if !item_data.is_solid(x, y):
				continue

			var slot_index = index + x + y * columns

			if slot_index < 0 or slot_index >= slot_data.size():
				continue
			if (index + x) / columns != index / columns:
				continue
			var item = slot_data[slot_index]
			if !item or (item is String):
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
			# Se o item tiver um buraco no formato (não é solido ali), ignora
			if data and !data.is_solid(x, y):
				continue
			
			var curr_index = index + x + y * columns
			
			if curr_index >= slot_data.size():
				return false
			
			if "is_blocked" in get_child(curr_index) and get_child(curr_index).is_blocked:
				return false
			
			# 2. Verifica se já tem item (lógica)
			if slot_data[curr_index] != null:
				return false
				
			var slot_visual = get_child(curr_index)
			
			if "is_blocked" in slot_visual and slot_visual.is_blocked:
				return false

			var splitX = index / columns != (index + x) / columns

			if splitX:
				return false

			else:
				return true
				
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

func consolidar_viagem() -> void:
	for child in get_children():
		if "sentado" in child:
			child.travar_no_assento()
			VariaveisGLobais.alunos_embarcados += 1


func salvar_dados_no_global():
	if !e_o_grid_do_onibus: return # O Ponto de ônibus não salva nada
	
	VariaveisGLobais.persistencia_onibus.clear()
	
	# Percorre todos os slots para achar itens
	# Usamos um array auxiliar para não salvar o mesmo item múltiplas vezes (já que ele ocupa vários slots)
	var itens_salvos: Array[Node] = []
	
	for i in range(slot_data.size()):
		var item = slot_data[i]
		
		# Verifica se é um item válido e se já não foi salvo
		if item and (item is Node) and not (item in itens_salvos):
			itens_salvos.append(item)
			
			# Salva as informações cruciais
			var info = {
				"posicao_index": i, # O índice onde o "canto superior esquerdo" do item está
				"resource_data": item.data, # O arquivo .tres (com rotação e tudo)
				"sentado": item.sentado # Se já estava travado
			}
			
			# Usa o índice como chave no dicionário global
			VariaveisGLobais.persistencia_onibus[i] = info
	consolidar_viagem()
	print("Dados do ônibus salvos no Global!")

func carregar_dados_do_global():
	if !e_o_grid_do_onibus: return
	if VariaveisGLobais.persistencia_onibus.is_empty(): return
	
	print("Carregando alunos do Global...")
	
	for index in VariaveisGLobais.persistencia_onibus:
			var info = VariaveisGLobais.persistencia_onibus[index]
			
			var novo_aluno = scene_item.instantiate()
			
			# 1. PASSA OS DADOS (O Resource já vem com dimensions trocado e is_rotated=true)
			novo_aluno.data = info["resource_data"]
			
			# 2. ADICIONA NA ÁRVORE (Aqui roda o _ready e aplica rotation_degrees = 90)
			add_child(novo_aluno)
			
			# 3. POSICIONA
			# Como o aluno já girou no passo 2, o tamanho (size) agora reflete a altura/largura corretas
			var coords = get_coords_from_slot_index(info["posicao_index"])
			novo_aluno.get_placed(coords)
			
			add_item_to_slot_data(novo_aluno, info["posicao_index"])
			
			if info.get("sentado", false):
				novo_aluno.travar_no_assento()
			
func reset_grid_data():
	# Preenche todo o array de dados com 'null', esquecendo os itens antigos
	slot_data.fill(null)

func _exit_tree():
	if e_o_grid_do_onibus:
		salvar_dados_no_global()
