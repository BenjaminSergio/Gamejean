extends Node2D

var dia_atual: int = 1
var dinheiro_total: float =0.00
var satisfacao:float =5.0
var preco_passagem:float =2.00
var cota:float= 20.00
var tempo_parada:float =15.0
var aviso:int = 0

func avancar_dia():
	dia_atual += 1

func strike():
	if dinheiro_total<cota:
		aviso+=1
		
