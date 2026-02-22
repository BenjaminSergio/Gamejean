extends Button


func _on_pressed() -> void:
	VariaveisGLobais.resetar_variaveis()
	get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
