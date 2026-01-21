extends Node2D

# --- REFERÊNCIAS ESSENCIAIS ---
@onready var canvas_pai = get_parent()
@export var grid_onibus: GridContainer # <--- ARRASTE O GRID DO ÔNIBUS AQUI NO INSPECTOR
@export var grid_ponto: GridContainer  # <--- ARRASTE O GRID DO PONTO AQUI
@export var timer: Timer

# --- CONFIGURAÇÕES VISUAIS ---
@export var posicao_escondida: float = -720.0 
@export var posicao_final: float = 90.0

# --- REFERÊNCIAS DE SPAWN ---
@export var alunos_resources: Array[ItemData] 
@export var scene_item: PackedScene 

var esta_aberto: bool = false
var em_animacao: bool = false

# --- FUNÇÃO MESTRA ---
func alternar_painel():
	if em_animacao: return
	
	if esta_aberto:
		subir_painel()
	else:
		descer_painel()

# --- ABRE O PONTO (E GERA NOVOS ALUNOS) ---
func descer_painel():
	if not (canvas_pai is CanvasLayer): return
	em_animacao = true
	
	# 1. LÓGICA: Gera os alunos ANTES do painel aparecer
	# Assim, quando ele descer, os alunos já estarão lá esperando.
	print("Chegando no ponto... Gerando novos alunos.")
	encher_ponto() 
	
	# 2. VISUAL: Animação de descida
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(canvas_pai, "offset:y", posicao_final, 1.0)
	
	tween.tween_callback(func():
		if timer: timer.start()
		esta_aberto = true
		em_animacao = false
	)

# --- FECHA O PONTO (E SALVA A VIAGEM) ---
func subir_painel():
	if not (canvas_pai is CanvasLayer): return
	em_animacao = true
	
	if timer: timer.stop()
	
	# 1. LÓGICA: Salva o estado do ônibus ANTES de ir embora
	# Isso garante que quem está sentado fica travado.
	if grid_onibus:
		print("Saindo do ponto... Consolidando viagem.")
		
		# Trava os alunos nos assentos
		if grid_onibus.has_method("consolidar_viagem"):
			grid_onibus.consolidar_viagem()
			
		# Opcional: Força o save no Global imediatamente
		if grid_onibus.has_method("salvar_dados_no_global"):
			grid_onibus.salvar_dados_no_global()
	else:
		printerr("ERRO: Grid do Ônibus não atribuído no Inspector do Ponto!")

	# 2. VISUAL: Animação de subida
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(canvas_pai, "offset:y", posicao_escondida, 1.0)
	
	tween.tween_callback(func():
		esta_aberto = false
		em_animacao = false
		# Limpa o ponto visualmente para economizar memória
		limpar_alunos_do_ponto()
	)

# --- LÓGICA DE GERENCIAMENTO DE ALUNOS ---

func encher_ponto():
	limpar_alunos_do_ponto()
	await get_tree().process_frame # Espera limpeza
	
	if scene_item == null:
		printerr("ERRO CRÍTICO: Você esqueceu de colocar o 'inventory_item.tscn' na variável 'Scene Item' do Inspector!")
		return
	
	if not grid_ponto: return

	# Cria 10 alunos novos
	for i in range(10): 
		var novo_aluno = scene_item.instantiate()
		if alunos_resources.size() > 0:
			novo_aluno.data = alunos_resources.pick_random()
		
		grid_ponto.add_child(novo_aluno)
		# Tenta encaixar; se não der, deleta
		if not grid_ponto.attempt_to_add_item_data(novo_aluno):
			novo_aluno.queue_free()

func limpar_alunos_do_ponto():
	if grid_ponto:
		for child in grid_ponto.get_children():
			child.queue_free()
			
		# 2. Limpeza LÓGICA (Zera o array slot_data) <--- ADICIONE ISSO
		if grid_ponto.has_method("reset_grid_data"):
			grid_ponto.reset_grid_data()
