extends TextureButton
@onready var painel = $"../../Control2"
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var nivel: int =1

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
	if VariaveisGLobais.dinheiro_total>=(nivel*15):
		print(nivel)
		
		VariaveisGLobais.dinheiro_total -= (nivel * 15)
		print(VariaveisGLobais.dinheiro_total)
		nivel+=1
		if nivel >= 5:
			self.disabled = true
			label.text = "BLOQUEADO"
	else:
		label.text = "Voce não tem dinheiro suficiente"
