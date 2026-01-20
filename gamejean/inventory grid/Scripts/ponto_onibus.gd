extends Node2D

@export var grid_ponto: GridContainer # Arraste o Grid do Ponto aqui
@export var alunos_resources: Array[ItemData] # Arraste seus resources de alunos aqui
@export var scene_item: PackedScene # Arraste a cena inventory_item.tscn

func _ready():
	encher_ponto()

func encher_ponto():
	# Tenta adicionar alunos até encher o grid do ponto
	for i in range(10): # Tenta colocar 10 alunos
		var novo_aluno = scene_item.instantiate()
		novo_aluno.data = alunos_resources.pick_random()
		
		# Adiciona visualmente primeiro para o código do grid funcionar
		grid_ponto.add_child(novo_aluno)
		
		# Tenta encaixar no grid logicamente
		var conseguiu = grid_ponto.attempt_to_add_item_data(novo_aluno)
		
		if not conseguiu:
			novo_aluno.queue_free() # Se não couber, deleta
