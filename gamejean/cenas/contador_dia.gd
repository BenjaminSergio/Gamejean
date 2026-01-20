extends Label

@onready var label_dia = $"."

func _ready():
	label_dia.text = "Dia: " + str(VariaveisGLobais.dia_atual)
