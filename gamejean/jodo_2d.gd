
extends Node2D

@onready var timer: Timer = $Timer
@onready var label_tempo: Label = $Label

func _ready():
	timer.wait_time = 5.00  # segundos
	timer.one_shot = true
	timer.start()

func _process(_delta):
	label_tempo.text = str(ceil(timer.time_left))

func _on_timer_timeout():
	VariaveisGLobais.avancar_dia()
	get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
