extends HBoxContainer

func _ready() -> void:
	var quadrados = get_children()
	var limite = min(VariaveisGLobais.aviso, quadrados.size())

	for i in range(quadrados.size()):
		quadrados[i].color = Color.WHITE 

	for i in range(limite):
		quadrados[i].color = Color.RED
