extends Node2D

@onready var label_dialogo: Label = $CanvasLayer/Control/PanelContainer/MarginContainer/Label
@onready var caixa: Control = $CanvasLayer/Control
@export var dialogos := {
	1: "Olá, hoje é o primeiro dia.",
	2: "Já estamos no segundo dia.",
	3: "O tempo passa rápido..."
}

var dialogo_visivel := false

func _ready():
	caixa.visible = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		toggle_dialogo()

func toggle_dialogo():
	dialogo_visivel = !dialogo_visivel

	if dialogo_visivel:
		var dia := VariaveisGLobais.dia_atual

		if dialogos.has(dia):
			label_dialogo.text = dialogos[dia]
		else:
			label_dialogo.text = "Não tenho mais nada a dizer."

	caixa.visible = dialogo_visivel
