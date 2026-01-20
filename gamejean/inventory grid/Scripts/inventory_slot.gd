extends ColorRect # Ou o tipo que for o seu Slot raiz

# Se marcado como true no Editor, nenhum passageiro pode sentar aqui (corredor)
@export var is_blocked: bool = false

func _ready():
	if is_blocked:
		modulate = Color(0, 0, 0, 0) # Exemplo: Torna invisível se for corredor
		# Ou mude a textura para parecer chão de ônibus
