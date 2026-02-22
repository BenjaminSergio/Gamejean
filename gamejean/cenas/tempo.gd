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
	label.text = "aumenta o tempo!\nnivel atual do Upgrade :" + str(nivel)+"\npreço do atual do upgrade: $" +str(nivel*5)
	if nivel >= 10:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if nivel>=10:
			self.disabled = true
			label.text = "BLOQUEADO"
	if VariaveisGLobais.dinheiro_total>=(nivel*5):
		print(nivel)
		VariaveisGLobais.tempo_parada+=5
		VariaveisGLobais.dinheiro_total -= (nivel * 5)
		nivel+=1
		print(VariaveisGLobais.tempo_parada)
		if nivel <= 10:
			label.text = "aumenta o tempo!\nnivel atual do Upgrade :" + str(nivel)+"\npreço do atual do upgrade: $" +str(nivel*5)
	else:
		label.text ="voce não possui dinheiro suficiente"
		if nivel >= 11:
			self.disabled = true
			label.text = "BLOQUEADO"
			AudioManager.play_sfx(son_jamanta)
			return
		AudioManager.play_sfx(son_upgrade)
