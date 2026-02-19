extends Node

@export var scene_aluno: PackedScene
@export var tipos_alunos: Array[ItemData]
@export var grid_ponto: GridContainer

@export var quantidade_minima: int = 3
@export var quantidade_maxima: int = 6

func _ready() -> void:
	gerar_fila_nova()

func gerar_fila_nova() -> void:
	for child in grid_ponto.get_children():
		pass

	var qtd = randi_range(quantidade_minima, quantidade_maxima)

	for i in range(qtd):
		tentar_criar_aluno()

func tentar_criar_aluno() -> void:
	var novo_aluno = scene_aluno.instantiate()

	var dados_aleatorios = tipos_alunos.pick_random()

	novo_aluno.data = dados_aleatorios

	grid_ponto.add_child(novo_aluno)

	var conseguiu = grid_ponto.attempt_to_add_item_data(novo_aluno)

	if not conseguiu:
		novo_aluno.queue_free()
