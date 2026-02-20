extends Label

@onready var label = $"."

func _ready():
	label.text = "preço da passagem: R$" + str(VariaveisGLobais.preco_passagem)
