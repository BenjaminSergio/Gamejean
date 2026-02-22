extends Button
@export var music: AudioStream
@export var music_proxima: AudioStream
@export var son_botao: AudioStream

func _ready() -> void:
	AudioManager.play_music(music)
	AudioManager.alterar_volume_musica(0.15)

func _on_pressed() -> void:
	VariaveisGLobais.resetar_variaveis()
	AudioManager.play_sfx(son_botao)
	AudioManager.play_music_random(music_proxima)
	AudioManager.alterar_volume_musica(0.25)
	get_tree().change_scene_to_file("res://cenas/covil_sg.tscn")
