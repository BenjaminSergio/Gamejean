extends Label

@onready var label_dnheiro = $"."

func _ready():
	label_dnheiro.text = "DINHEIRO: R$" + str(VariaveisGLobais.dinheiro_total)
