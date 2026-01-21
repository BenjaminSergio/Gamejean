
extends Node2D

@onready var timer: Timer = $Timer
@onready var label_tempo: Label = $Label
@export var grid_onibus: GridContainer

func _ready():
	timer.wait_time = 5.00  # segundos
	timer.one_shot = true
	timer.start()

func _process(_delta):
	label_tempo.text = str(ceil(timer.time_left)) + "s"

func _on_timer_timeout():

	if grid_onibus and grid_onibus.has_method("salvar_dados_no_global"):
		grid_onibus.salvar_dados_no_global()

	VariaveisGLobais.avancar_dia()
	#get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
