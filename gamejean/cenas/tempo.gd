extends TextureButton
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var painel = $"../../Control2"
@onready var nivel: int =1


func _ready():
	painel.visible = false
	
func _on_mouse_entered() -> void:
	painel.visible = !painel.visible
	label.text = "aumenta o tempo!, nivel atual do Upgrade :" + str(nivel)+"\n  preço do atual do upgrade: $" +str(nivel*5)
	if nivel >= 5:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if VariaveisGLobais.dinheiro_total>=(nivel*5):
		print(nivel)
		VariaveisGLobais.tempo_parada+=5
		
		VariaveisGLobais.dinheiro_total -= (nivel * 5)
		nivel+=1
		print(VariaveisGLobais.tempo_parada)
		if nivel >= 11:
			self.disabled = true
			label.text = "BLOQUEADO"
	else:
		label.text = "Voce não tem dinheiro suficiente"
