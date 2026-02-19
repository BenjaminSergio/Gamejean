extends Node2D

# --- REFERÊNCIAS ---
@onready var canvas_pai = get_parent()
@onready var label_tempo: Label = $Label 
@export var grid_onibus: GridContainer
@export var grid_ponto: GridContainer

# Arraste o nó BusController (C#) para cá no Inspector
@export var controlador_onibus: Node 

# --- CONFIGURAÇÕES ---
@export var posicao_escondida: float = -720.0 
@export var posicao_final: float = 90.0
@export var alunos_resources: Array[ItemData] 
@export var scene_item: PackedScene 

#--- ESTADOS E CONTROLE ---
@export var tempo_no_ponto: int = 5 
@export var numero_paradas: int = -2
@export var numero_paradas_para_covil: int = 3
@export var  obstaculosAtingidos: int = 0
var alunos_entraram: int = 0 # contador de alunos que entraram no ônibus
# Estados
var esta_aberto: bool = false
var em_animacao: bool = false
var pode_interagir: bool = false

# Variável de controle para cancelar o await se o painel subir antes da hora
var cancelar_contagem: bool = false 

func _ready() -> void:
	if label_tempo: label_tempo.text = "Aguardando"
	subir_painel() # Começa fechado
	if grid_onibus:
		grid_onibus.child_entered_tree.connect(_on_aluno_entrou_onibus)

# (Removemos o _process e o _on_timer_timeout, não são mais necessários)

func alternar_painel():
	if em_animacao: return
	if esta_aberto: subir_painel()
	else: descer_painel()

# --- ABRIR PONTO ---
func descer_painel():
	if not (canvas_pai is CanvasLayer): return
	em_animacao = true
	
	print("Descendo alunos")
	esvaziar_onibus()

	print("Chegando... Gerando alunos.")
	encher_ponto() 
	
	# Animação de descida
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(canvas_pai, "offset:y", posicao_final, 1.0)
	
	# Espera a animação terminar usando await
	await tween.finished
	
	esta_aberto = true
	em_animacao = false
	
	# --- INICIA O LOOP DE TEMPO ---
	iniciar_contagem(tempo_no_ponto) # 5 segundos

# --- NOVA FUNÇÃO DE TEMPO (AWAIT) ---
func iniciar_contagem(segundos: int):
	pode_interagir = true
	cancelar_contagem = false # Reseta cancelamento
	
	# Loop reverso: 5, 4, 3, 2, 1, 0
	for i in range(segundos, -1, -1):
		# Se alguém mandou cancelar (ex: painel subiu), para tudo
		if cancelar_contagem or not esta_aberto: 
			return 
			
		if label_tempo: label_tempo.text = str(i) + "s"
		
		# Espera 1 segundo real
		await get_tree().create_timer(1.0).timeout
	
	# Se o loop acabou sem ser cancelado, finaliza a estadia
	finalizar_estadia()

func finalizar_estadia():
	print("Tempo esgotado! Encerrando...")
	pode_interagir = false
	
	if grid_onibus and grid_onibus.has_method("salvar_dados_no_global"):
		grid_onibus.salvar_dados_no_global()
	
	if controlador_onibus and controlador_onibus.has_method("RestartPath"):
		controlador_onibus.RestartPath()
	else:
		subir_painel() # Fallback

# --- FECHAR PONTO ---
func subir_painel():
	if not (canvas_pai is CanvasLayer): return
	
	em_animacao = true
	pode_interagir = false
	
	if label_tempo: label_tempo.text = "Viajando..."

	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(canvas_pai, "offset:y", posicao_escondida, 1.0)
	
	await tween.finished
	
	numero_paradas += 1
	
	esta_aberto = false
	em_animacao = false
	consolidar_viagem()
	limpar_alunos_do_ponto()
	if numero_paradas >= numero_paradas_para_covil:
		VariaveisGLobais.dinheiro_diario=alunos_entraram*VariaveisGLobais.preco_passagem
		VariaveisGLobais.avancar_dia()
		
		
		
func consolidar_viagem():
	if grid_onibus:
		if grid_onibus.has_method("consolidar_viagem"): grid_onibus.consolidar_viagem()
		if grid_onibus.has_method("salvar_dados_no_global"): grid_onibus.salvar_dados_no_global()

# --- GERENCIAMENTO DE ITENS ---
func encher_ponto():
	limpar_alunos_do_ponto()
	await get_tree().process_frame 
	
	if not scene_item or not grid_ponto: return

	for i in range(10): 
		var novo_aluno = scene_item.instantiate()
		if alunos_resources.size() > 0: novo_aluno.data = alunos_resources.pick_random()
		grid_ponto.add_child(novo_aluno)
		if not grid_ponto.attempt_to_add_item_data(novo_aluno): novo_aluno.queue_free()

	
func limpar_alunos_do_ponto():
	if grid_ponto:
		for i in range(grid_ponto.slot_data.size()):
			var item = grid_ponto.slot_data[i]
			if item != null and is_instance_valid(item):
				item.queue_free()
				grid_ponto.slot_data[i] = null
		if grid_ponto.has_method("reset_grid_data"): grid_ponto.reset_grid_data()

func esvaziar_onibus():
	# 1. Rolar um número de 1 a 3 para a quantidade de alunos que descerão
	var quantidade_para_descer = randi_range(1, 3)
	
	if not grid_onibus:
		return

	# 2. Identificar quais alunos estão atualmente no ônibus
	# Filtramos apenas os filhos que são do tipo InventoryItem (os alunos visíveis)
	var alunos_no_grid = []
	for child in grid_onibus.get_children():
		# Verificamos se o nó tem a propriedade 'data' que define um aluno/item
		if child.get("data") is ItemData:
			alunos_no_grid.append(child)

	# Se não houver ninguém no ônibus, cancelamos a função
	if alunos_no_grid.is_empty():
		print("O ônibus já está vazio.")
		return

	# Ajustamos a quantidade caso o número sorteado seja maior que o total de alunos
	quantidade_para_descer = min(quantidade_para_descer, alunos_no_grid.size())
	print("Sorteado: ", quantidade_para_descer, " alunos descerão.")

	# 3. Remover os alunos aleatoriamente
	for i in range(quantidade_para_descer):
		if alunos_no_grid.is_empty():
			break
			
		# Sorteia um índice da lista de alunos presentes
		var indice_aleatorio = randi() % alunos_no_grid.size()
		var aluno_para_remover = alunos_no_grid[indice_aleatorio]
		
		# Removemos do sistema de grid (limpa os slots ocupados no slot_data)
		if grid_onibus.has_method("remove_item"):
			grid_onibus.remove_item(aluno_para_remover)
		
		# Removemos da lista temporária para não sortear o mesmo no próximo loop
		alunos_no_grid.remove_at(indice_aleatorio)
		
		# Deletamos o aluno da cena
		aluno_para_remover.queue_free()


func _on_aluno_entrou_onibus(node):
	# verifica se o objeto que entrou é um aluno
	if node.get("data") is ItemData:
		alunos_entraram += 1
		print("Aluno entrou no ônibus! Total:", alunos_entraram)
