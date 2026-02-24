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
	label.text = "abaixa a 5% * o nivel do upgrade a cota diaria cota diaria,\nnivel atual do Upgrade :" + str(nivel)+"\npreço do atual do upgrade: $" +str(nivel*15)
	if nivel >= 5:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible

func _on_pressed() -> void:
	if nivel>=5:
			self.disabled = true
			label.text = "BLOQUEADO"
			print("jamanta")
			AudioManager.play_sfx(son_jamanta)

	if VariaveisGLobais.dinheiro_total>=(nivel*15):
		print(nivel)
		VariaveisGLobais.dinheiro_total -= (nivel * 15)
		VariaveisGLobais.cota=VariaveisGLobais.cota*(1-(0.05*nivel))
		nivel+=1
		print(VariaveisGLobais.dinheiro_total)
		AudioManager.play_sfx(son_upgrade)
		if nivel<=5:
			label.text = "abaixa a 5% * o nivel do upgrade a cota diaria cota diaria,\nnivel atual do Upgrade :" + str(nivel)+"\npreço do atual do upgrade: $" +str(nivel*15)
	else:
		label.text ="voce não possui dinheiro suficiente"
		if nivel >= 5:
			self.disabled = true
			label.text = "BLOQUEADO"
			AudioManager.play_sfx(son_jamanta)
