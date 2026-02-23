extends Label

@onready var label = $"."

func _ready():
	label.text = "saldo: R$" + str(VariaveisGLobais.saldo)
