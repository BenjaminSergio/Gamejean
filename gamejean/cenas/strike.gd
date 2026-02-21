extends TextureButton
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var painel = $"../../Control2"
@onready var nivel: int =1
@export var son_upgrade: AudioStream
@export var son_jamanta: AudioStream
func _ready():
	painel.visible = false
func _on_mouse_entered() -> void:
	painel.visible = !painel.visible
	label.text = "tira um strike!"
	if nivel >= 5:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if VariaveisGLobais.aviso==0:
			self.disabled = true
			AudioManager.play_sfx(son_jamanta)
			print("jamanta")
	else:
		if VariaveisGLobais.dinheiro_total>=(nivel*15):
			VariaveisGLobais.aviso-=1
			print(nivel)
			nivel+=1
			VariaveisGLobais.dinheiro_total -= (nivel * 15)
			print(VariaveisGLobais.aviso)
			if nivel >= 5:
				self.disabled = true
				label.text = "BLOQUEADO"
				AudioManager.play_sfx(son_jamanta)
				return
			AudioManager.play_sfx(son_upgrade)
