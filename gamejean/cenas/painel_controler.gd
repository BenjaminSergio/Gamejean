extends Node

# Mudei para Node2D para garantir que você arraste o objeto certo, 
# mas se o inspector reclamar, pode voltar para Node.
@export var painel_ponto: Node 

func _input(event: InputEvent) -> void:
	# Mudei de _unhandled_input para _input para ter prioridade total
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			print("Detecetei a tecla Q!") # Debug 1
			#acionar_botao()

func acionar_botao():
	# Verificação 1: A variável foi preenchida?
	if painel_ponto == null:
		printerr("ERRO CRÍTICO: Você esqueceu de arrastar o nó 'PontoDeOnibus' para a variável 'Painel Ponto' no Inspector deste script!")
		return

	# Verificação 2: O nó arrastado tem o script certo?
	if not painel_ponto.has_method("alternar_painel"):
		printerr("ERRO: O nó que você arrastou (" + painel_ponto.name + ") NÃO tem a função 'alternar_painel'. Verifique se você arrastou o nó certo.")
		return

	# Se chegou aqui, tudo está certo
	print("Chamando alternar_painel no nó: ", painel_ponto.name)
	painel_ponto.alternar_painel()
