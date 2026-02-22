extends Node

# Canais de áudio que estarão sempre disponíveis
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var loop_sfx_player: AudioStreamPlayer

func _ready():
	# Configura o player de música
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Configura o player de efeitos
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)

	# Configura o player de efeitos em loop
	loop_sfx_player = AudioStreamPlayer.new()
	loop_sfx_player.bus = "SFXLoop"
	add_child(loop_sfx_player)

func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	music_player.play()

func play_music_random(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	var duracao_total = stream.get_length()
	var ponto_inicio = randf_range(0.0, duracao_total)
	music_player.play(ponto_inicio)

func play_sfx(stream: AudioStream):
	var temporary_sfx = AudioStreamPlayer.new()
	temporary_sfx.stream = stream
	temporary_sfx.bus = "SFX"
	add_child(temporary_sfx)
	temporary_sfx.play()
	temporary_sfx.finished.connect(temporary_sfx.queue_free)

func play_sfx_from_position(stream: AudioStream, start_time: float = 0.0):
	var temporary_sfx = AudioStreamPlayer.new()
	temporary_sfx.stream = stream
	temporary_sfx.bus = "SFX"
	add_child(temporary_sfx)
	temporary_sfx.play(start_time) # Começa a tocar do segundo X
	temporary_sfx.finished.connect(temporary_sfx.queue_free)

func play_loop_sfx(stream: AudioStream):
	# Se já houver um som tocando, ele para
	if loop_sfx_player.playing:
		loop_sfx_player.stop()
	
	# Configura o novo som
	loop_sfx_player.stream = stream
	loop_sfx_player.play()

func alterar_volume_musica(valor_linear: float):
	var volume_db = linear_to_db(clamp(valor_linear, 0.0, 1.0))
	music_player.volume_db = volume_db

func stop_loop_sfx():
	loop_sfx_player.stop()

func stop_all_sfx():
	sfx_player.stop()
	loop_sfx_player.stop()