extends Node2D

# 1. Adicione esta variável para poder arrastar o ônibus no Inspector
@export var controlador_onibus: Node 

@onready var timer: Timer = $Timer
@onready var label_tempo: Label = $Label
@export var grid_onibus: GridContainer

func _ready():
	timer.wait_time = VariaveisGLobais.tempo_parada  # segundos
	timer.one_shot = true
	timer.start()

func _process(_delta):
	# Adicionei uma verificação para não mostrar números negativos ou quebrados
	if !timer.is_stopped():
		label_tempo.text = str(ceil(timer.time_left)) + "s"
	else:
		label_tempo.text = "0s"

func _on_timer_timeout():
	# 1. Salva os dados
	if grid_onibus and grid_onibus.has_method("salvar_dados_no_global"):
		grid_onibus.salvar_dados_no_global()

	# 2. Avança o dia
	# (Verifica se o Singleton existe para não crashar se mudar de nome)
	# if typeof(VariaveisGLobais) != TYPE_NIL:
	# 	VariaveisGLobais.avancar_dia()
	
	# 3. CHAMA O ÔNIBUS (C#) PARA SAIR
	if controlador_onibus:
		if controlador_onibus.has_method("RestartPath"):
			controlador_onibus.RestartPath()
		else:
			printerr("ERRO: O nó do ônibus não tem o método 'RestartPath'. Verifique o script C#.")
	else:
		printerr("ERRO: Variável 'Controlador Onibus' vazia! Arraste o nó do ônibus para o Inspector deste script.")
