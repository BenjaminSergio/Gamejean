extends Node2D

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

func avancar_dia():
	print(dinheiro_diario)
	dia_atual += 1
	if cota>dinheiro_diario:
		aviso+=1
		print(aviso)
	else :
		dinheiro_diario=dinheiro_diario-cota
		dinheiro_total=dinheiro_total+dinheiro_diario
	print(' 2 peida n xerequinha')
	print(dinheiro_diario)
	
	strike()

	

func strike():
	if aviso>=3:
		#game over
		print('chupatodos')
		get_tree().change_scene_to_file('res://main_menu.tscn')
	else:
		print('chupetinha')
		get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
		
