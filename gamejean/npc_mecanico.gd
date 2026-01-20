extends Node2D

@onready var label_dialogo: Label = $CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/Label
@onready var caixa: Control = $CanvasLayer/Control
@onready var opcoes: Control = $CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/HBoxContainer
@onready var btn_sim: Button = $CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/HBoxContainer/sim
@onready var btn_nao: Button = $"CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/HBoxContainer/não"


@export var dialogos := {
	1: "Olá, hoje é o primeiro dia, sou GILMAR o mecanico, sempre que sobrar um dinheiro vem conversar comigo, posso melhroar o seu onibus",
	2: "Já estamos no segundo dia.",
	3: "O tempo passa rápido..."
}



var dialogo_visivel := false
var aguardando_resposta := false

func _ready():
	caixa.visible = false
	opcoes.visible = false

	btn_sim.pressed.connect(_on_sim_pressed)
	btn_nao.pressed.connect(_on_nao_pressed)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not dialogo_visivel:
			abrir_dialogo()

func abrir_dialogo():
	dialogo_visivel = true
	caixa.visible = true

	var dia := VariaveisGLobais.dia_atual

	if dialogos.has(dia):
		label_dialogo.text = dialogos[dia]
	else:
		label_dialogo.text = "Não tenho mais nada a dizer."

	# A partir do segundo dia
	if dia >= 2:
		aguardando_resposta = true
		opcoes.visible = true
	else:
		aguardando_resposta = false
		opcoes.visible = false

func fechar_dialogo():
	dialogo_visivel = false
	caixa.visible = false
	opcoes.visible = false
	aguardando_resposta = false

func _on_sim_pressed():
	# Abrir loja
	label_dialogo.text= "vem ca ver a minha ferramenta"
	
	fechar_dialogo()
	abrir_loja()

func _on_nao_pressed():
	fechar_dialogo()

func abrir_loja():
	# Exemplo
	
	label_dialogo.text= "vem ca ver a minha ferramenta"
	get_tree().change_scene_to_file("res://cenas/loja.tscn")
	# ou mostrar um Control da loja"res://cenas/loja.tscn"
