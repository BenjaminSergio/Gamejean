extends Node2D

@onready var label_dialogo: Label = $CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/Label
@onready var caixa: Control = $CanvasLayer/Control
@onready var opcoes: Control = $CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/HBoxContainer
@onready var btn_sim: Button = $CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/HBoxContainer/sim
@onready var btn_nao: Button = $"CanvasLayer/Control/PanelContainer/TextureRect/MarginContainer/HBoxContainer/não"


@export var dialogos := {
1: "Olá, hoje é o primeiro dia. Sou GILMAR, o mecânico. Sempre que sobrar um dinheiro, venha conversar comigo; posso melhorar o seu ônibus.",
2: "Já estamos no segundo dia. Se você me trouxer uns trocados, eu te mostro a minha FERRAMENTA.\n IR PARA LOJA????",
3: "Quer um gole do meu suco de laranja????\n IR PARA LOJA????",
4: "Sou apaixonado por carros. Você viu o novo Golf??? Tá um tesão.\n IR PARA LOJA????",
5: "E, mano, hoje estou meio triste. Minha mulher me ligou; hoje não vou poder ver as crianças.\n IR PARA LOJA????",
6: "Vamos tomar uma cerveja qualquer dia desses, mas fora do trabalho, viu.\n IR PARA LOJA????",
7: "Eu gosto dessa garagem, fico em casa perto desses monstros.\n IR PARA LOJA????",
8: "Rapaz, sempre vejo aquele filme Carros, e aquela Sally tem um belo bagageiro.\n IR PARA LOJA????",
9: "Você sabia que eu já fui busólogo????\n IR PARA LOJA????",
10: "Pô, a minha ex não aceita meu relacionamento com o Miguel.\n IR PARA LOJA????",
11: "Sempre fui apaixonado por carros. Parei de andar de velotrol aos 16 anos, quando comprei minha primeira moto.\n IR PARA LOJA????",
12: "Aiai, esses avisos... Você não pode deixar a peteca cair.\n IR PARA LOJA????",
13: "Bora para a praia. O Miguel pode te dar carona.\n IR PARA LOJA????",
14: "Rapaz, quando subo no Miguel... aaa, desculpa, isso é um pouco inapropriado.\n IR PARA LOJA????",
15: "Nunca tomei um aviso, kkkk. Esse suco não tem álcool, só cachaça.\n IR PARA LOJA????",
16: "Quando vi o Miguel pela primeira vez, ele tava lindo.\n IR PARA LOJA????",
17: "Ônibus foi a minha paixão antes dos meus filhos e do Miguel.\n IR PARA LOJA????",
18: "O Miguel fica lindo de vermelho. Vou levar ele na loja lá perto de casa.\n IR PARA LOJA????",
19: "Vai tomar um pouco de suco. Esses dias têm sido difíceis.\n IR PARA LOJA????",
20: "Troquei a pintura do Miguel. Espera, você não sabia que ele era um carro???\n IR PARA LOJA????",
21: "Rapaz, você é realmente bom. Vou sentir a sua falta.\n IR PARA LOJA????"
}
@export var son_botao: AudioStream



var dialogo_visivel := false
var aguardando_resposta := false

func _ready():
	caixa.visible = false
	opcoes.visible = false

	btn_sim.pressed.connect(_on_sim_pressed)
	btn_nao.pressed.connect(_on_nao_pressed)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		AudioManager.play_sfx(son_botao)
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
