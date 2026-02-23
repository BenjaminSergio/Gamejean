extends Label

@onready var label = $"."

func _ready():
	label.text = "cota diaria: R$" + str(VariaveisGLobais.cota)
