extends Node2D

var dia_atual: int = 1
var dinheiro: float =0.00
var satisfacao:float =5.0
var persistencia_onibus: Dictionary = {}

func avancar_dia():
	dia_atual += 1
