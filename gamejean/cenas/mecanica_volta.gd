extends TextureButton
@export var son_botao: AudioStream

func _on_pressed() -> void:
	AudioManager.play_sfx(son_botao)
	AudioManager.alterar_volume_musica(0.25)
	get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
