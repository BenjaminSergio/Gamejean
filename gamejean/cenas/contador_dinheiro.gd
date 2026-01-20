extends Label

@onready var label_dia = $"."

func _ready():
	label_dia.text = "DIA: " + str(VariaveisGLobais.dia_atual)
