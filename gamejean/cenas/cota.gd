extends TextureButton
@onready var painel = $"../../Control2"
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var nivel: int =1
@export var son_upgrade: AudioStream
@export var son_jamanta: AudioStream
func _ready():
	painel.visible = false

func _on_mouse_entered() -> void:
	painel.visible = true
	label.text = "abaixa a cota diaria"
	if nivel >= 5:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if nivel>=5:
			print("jamanta")
			AudioManager.play_sfx(son_jamanta)
			return
	if VariaveisGLobais.dinheiro_total>=(nivel*15):
		print(nivel)
		nivel+=1
		VariaveisGLobais.dinheiro_total -= (nivel * 15)
		print(VariaveisGLobais.dinheiro_total)
		if nivel >= 5:
			self.disabled = true
			label.text = "BLOQUEADO"
			AudioManager.play_sfx(son_jamanta)
			return
		AudioManager.play_sfx(son_upgrade)
