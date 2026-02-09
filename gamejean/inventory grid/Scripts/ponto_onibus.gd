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

# Estados
var esta_aberto: bool = false
var em_animacao: bool = false
var pode_interagir: bool = false

# Variável de controle para cancelar o await se o painel subir antes da hora
var cancelar_contagem: bool = false 

func _ready() -> void:
	if label_tempo: label_tempo.text = "Aguardando"
	subir_painel() # Começa fechado

# (Removemos o _process e o _on_timer_timeout, não são mais necessários)

func alternar_painel():
	if em_animacao: return
	if esta_aberto: subir_painel()
	else: descer_painel()

# --- ABRIR PONTO ---
func descer_painel():
	if not (canvas_pai is CanvasLayer): return
	em_animacao = true
	
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
	iniciar_contagem(5) # 5 segundos

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
	
	# 1. Salvar
	if grid_onibus and grid_onibus.has_method("salvar_dados_no_global"):
		grid_onibus.salvar_dados_no_global()
	
	# 2. Avançar Dia
	if typeof(VariaveisGLobais) != TYPE_NIL:
		VariaveisGLobais.avancar_dia()
	
	# 3. Chamar C# para sair
	if controlador_onibus and controlador_onibus.has_method("RestartPath"):
		controlador_onibus.RestartPath()
	else:
		subir_painel() # Fallback

# --- FECHAR PONTO ---
func subir_painel():
	if not (canvas_pai is CanvasLayer): return
	
	# IMPORTANTE: Avisa o loop do await para parar, senão ele continua contando no fundo
	cancelar_contagem = true 
	
	em_animacao = true
	pode_interagir = false
	
	if label_tempo: label_tempo.text = "Viajando..."
	
	# Salva de segurança
	if grid_onibus:
		if grid_onibus.has_method("consolidar_viagem"): grid_onibus.consolidar_viagem()
		if grid_onibus.has_method("salvar_dados_no_global"): grid_onibus.salvar_dados_no_global()

	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(canvas_pai, "offset:y", posicao_escondida, 1.0)
	
	await tween.finished
	
	esta_aberto = false
	em_animacao = false
	limpar_alunos_do_ponto()

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