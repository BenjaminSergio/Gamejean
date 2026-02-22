extends Node2D
const SAVE_PATH = "user://savegame.json"


var dia_atual: int = 1
var dinheiro_total: float =0
var satisfacao:float =5.0

var preco_passagem:float =2.00
var cota:float= 10.00
var tempo_parada:float =15.0
var aviso:int = 0
var alunos_embarcados: int = 0
var obstaculos_atingidos: int = 0
var persistencia_onibus: Dictionary = {}
var dinheiro_diario: float=0
var saldo:float=0

func avancar_dia():
	print(dinheiro_diario)
	saldo=dinheiro_diario
	dia_atual += 1
	if cota>dinheiro_diario:
		aviso+=1
		print(aviso)
	else :
		dinheiro_diario=dinheiro_diario-cota
		dinheiro_total=dinheiro_total+dinheiro_diario
	print(dinheiro_diario)
	strike()
	


func strike():
	if aviso>=3:
		#game over
		print('chupatodos')
		get_tree().change_scene_to_file('res://main_menu.tscn')
	else:
		print('chupetinha')
		salvar_jogo()
		get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
		
func get_save_stats() -> Dictionary:
	return {
		"dia_atual": dia_atual,
		"dinheiro_total": dinheiro_total,
		"satisfacao": satisfacao,
		"preco_passagem": preco_passagem,
		"cota": cota,
		"tempo_parada": tempo_parada,
		"aviso": aviso,
		"alunos_embarcados": alunos_embarcados,
		"obstaculos_atingidos": obstaculos_atingidos,
		"persistencia_onibus": persistencia_onibus,
		"dinheiro_diario": dinheiro_diario,
		"saldo": saldo
	}

# FUNÇÃO PARA APLICAR OS DADOS CARREGADOS
func load_save_stats(dados: Dictionary):
	dia_atual = dados.get("dia_atual", 1)
	dinheiro_total = dados.get("dinheiro_total", 0.0)
	satisfacao = dados.get("satisfacao", 5.0)
	preco_passagem = dados.get("preco_passagem", 2.0)
	cota = dados.get("cota", 10.0)
	tempo_parada = dados.get("tempo_parada", 15.0)
	aviso = dados.get("aviso", 0)
	alunos_embarcados = dados.get("alunos_embarcados", 0)
	obstaculos_atingidos = dados.get("obstaculos_atingidos", 0)
	persistencia_onibus = dados.get("persistencia_onibus", {})
	dinheiro_diario = dados.get("dinheiro_diario", 0.0)
	saldo = dados.get("saldo", 0.0)

func salvar_jogo():
	var arquivo = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var dados = get_save_stats() 
	var json_string = JSON.stringify(dados)
	arquivo.store_line(json_string)
	print("Progresso salvo com sucesso!")
	
func carregar_jogo():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Não achei nenhum arquivo de save!")
		return

	var arquivo = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.new()
	var erro = json.parse(arquivo.get_line())
	
	if erro == OK:
		var dados = json.get_data()
		# Aqui a mágica acontece: as variáveis lá de cima recebem os valores novos
		dia_atual = dados.get("dia_atual", 1)
		dinheiro_total = dados.get("dinheiro_total", 0.0)
		satisfacao = dados.get("satisfacao", 5.0)
		preco_passagem = dados.get("preco_passagem", 2.00)
		cota = dados.get("cota", 10.00)
		tempo_parada = dados.get("tempo_parada", 15.0)
		aviso = dados.get("aviso", 0)
		alunos_embarcados = dados.get("alunos_embarcados", 0)
		obstaculos_atingidos = dados.get("obstaculos_atingidos", 0)
		persistencia_onibus = dados.get("persistencia_onibus", {})
		dinheiro_diario = dados.get("dinheiro_diario", 0.0)
		saldo = dados.get("saldo", 0.0)
		get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")

func resetar_variaveis():
	dia_atual = 1
	dinheiro_total = 0.0
	satisfacao = 5.0
	preco_passagem = 2.00
	cota = 10.00
	tempo_parada = 15.0
	aviso = 0
	alunos_embarcados = 0
	obstaculos_atingidos = 0
	persistencia_onibus = {}
	dinheiro_diario = 0.0
	saldo = 0.0
	print("Variáveis resetadas para o padrão de Novo Jogo!")
