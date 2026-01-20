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
		if data.is_rotated:
			rotation_degrees = 90
		else:
			rotation_degrees = 0
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

func get_placed(pos: Vector2) -> void:
	is_picked = false
	global_position = pos + (size/2)
	z_index = 1
	z_as_relative = true
	anchor_point = global_position - size / 2
	remove_from_group("held_items")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if is_picked:
				#do_roration()
				return

func do_roration() -> void:
	# 1. Atualiza a lógica do Grid (Matemática)
	if data.grid_pattern.is_empty():
		data.dimensions = Vector2i(data.dimensions.y, data.dimensions.x)
	else:
		# Se quisermos limitar a apenas 0 e 90 graus, precisamos de cuidado aqui.
		# A sua lógica atual de matriz gira sempre +90 no sentido horário.
		# Para um toggle simples (0 <-> 90), precisaríamos inverter a matriz na volta.
		# Porem, para manter seu código simples, vamos manter a rotação da matriz
		# mas travar o VISUAL em 0 ou 90 para não confundir o jogador.
		
		var old_width = data.dimensions.x
		var old_height = data.dimensions.y

		var new_pattern: Array[bool] = []
		new_pattern.resize(old_height * old_width)
		new_pattern.fill(false)

		for y in range(old_height):
			for x in range(old_width):
				var old_index = x + y * old_width
				var is_solid = data.grid_pattern[old_index]
				
				# Rotação Padrão
				var new_x = (old_height - 1) - y
				var new_y = x
				
				var new_width = old_height
				var new_index = new_y * new_width + new_x
				new_pattern[new_index] = is_solid
				
		data.grid_pattern = new_pattern
		data.dimensions = Vector2i(old_height, old_width)
	
	# 2. Atualiza o Estado
	data.is_rotated = !data.is_rotated
	
	# 3. Animação Visual (CORREÇÃO AQUI)
	var tween = create_tween()
	
	# Em vez de somar (+90), vamos para o ALVO.
	# Se está rotacionado (true) vai para 90. Se não (false), volta para 0.
	var angulo_alvo = 90.0 if data.is_rotated else 0.0
	
	tween.tween_property(self, "rotation_degrees", angulo_alvo, 0.3)
func travar_no_assento() -> void:
	sentado = true
	modulate = Color(0.5, 0.5, 0.5, 1)