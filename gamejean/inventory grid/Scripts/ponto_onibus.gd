extends Node2D

# --- MOVIMENTAÇÃO (CANVAS LAYER) ---
@onready var canvas_pai = get_parent()
@export var posicao_escondida: float = -720.0 
@export var posicao_final: float = 0.0

# --- REFERÊNCIAS DO JOGO ---
@export var timer: Timer
@export var grid_ponto: GridContainer
@export var alunos_resources: Array[ItemData] 
@export var scene_item: PackedScene 

# --- ESTADOS ---
var esta_aberto: bool = false
var em_animacao: bool = false

func _ready():
	# Configura a posição inicial do CanvasLayer imediatamente
	if canvas_pai is CanvasLayer:
		canvas_pai.offset.y = posicao_escondida
	else:
		printerr("ERRO CRÍTICO: O pai do PontoDeOnibus DEVE ser um CanvasLayer!")

	if timer: timer.stop()

# --- FUNÇÃO MESTRA (CHAMADA PELO 'Q') ---
func alternar_painel():
	if em_animacao: return
	
	if esta_aberto:
		subir_painel()
	else:
		descer_painel()

# --- ANIMAÇÃO DE DESCIDA ---
func descer_painel():
	if not (canvas_pai is CanvasLayer): return
	
	em_animacao = true
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# Move o CanvasLayer inteiro
	tween.tween_property(canvas_pai, "offset:y", posicao_final, 1.0)
	
	# CALLBACK: O que acontece quando o painel termina de descer?
	tween.tween_callback(func():
		print("Painel desceu. Iniciando jogo...")
		encher_ponto() # Gera os alunos
		if timer: timer.start() # Inicia a contagem
		esta_aberto = true
		em_animacao = false
	)

# --- ANIMAÇÃO DE SUBIDA ---
func subir_painel():
	if not (canvas_pai is CanvasLayer): return

	em_animacao = true
	if timer: timer.stop() # Para o tempo se fechar manualmente
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# Move o CanvasLayer de volta pra cima
	tween.tween_property(canvas_pai, "offset:y", posicao_escondida, 1.0)
	
	# CALLBACK: O que acontece quando o painel termina de subir?
	tween.tween_callback(func():
		print("Painel subiu.")
		esta_aberto = false
		em_animacao = false
		
		# Limpa os alunos para economizar memória (opcional)
		limpar_alunos()
	)

# --- LÓGICA DE ALUNOS ---
func encher_ponto():
	limpar_alunos()
	
	# Pequeno delay para garantir limpeza
	await get_tree().process_frame
	
	if not grid_ponto: return

	for i in range(10): 
		var novo_aluno = scene_item.instantiate()
		if alunos_resources.size() > 0:
			novo_aluno.data = alunos_resources.pick_random()
		
		grid_ponto.add_child(novo_aluno)
		var conseguiu = grid_ponto.attempt_to_add_item_data(novo_aluno)
		if not conseguiu:
			novo_aluno.queue_free()

func limpar_alunos():
	if grid_ponto:
		for child in grid_ponto.get_children():
			child.queue_free()
