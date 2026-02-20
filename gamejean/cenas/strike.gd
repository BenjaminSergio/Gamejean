extends TextureButton
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var painel = $"../../Control2"
@onready var nivel: int =1
func _ready():
	painel.visible = false
func _on_mouse_entered() -> void:
	painel.visible = !painel.visible
	label.text = "tira um strike!, nivel atual do Upgrade :" + str(nivel)+"\n  preço do atual do upgrade: $" +str(nivel*15)
	if nivel >= 5:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if VariaveisGLobais.aviso==0:
			label.text = "Voce não pode comprar esse upgrade, pois n tem avisos"
			self.disabled = true
	else:
		if VariaveisGLobais.dinheiro_total>=(nivel*15):
			VariaveisGLobais.aviso-=1
			print(nivel)
			VariaveisGLobais.dinheiro_total -= (nivel * 15)
			nivel+=1
			print(VariaveisGLobais.aviso)
			if nivel >= 5:
				self.disabled = true
				label.text = "BLOQUEADO"
		else:
			label.text = "Voce não tem dinheiro suficiente"
