extends TextureButton
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var painel = $"../../Control2"
@onready var nivel: int =1
func _ready():
	painel.visible = false
func _on_mouse_entered() -> void:
	painel.visible = !painel.visible
	label.text = "tira um strike!\nvoce pode comprar esse upgrade " + str(6-nivel)+" veses\npreço do atual do upgrade: $" +str(nivel*15)
	if VariaveisGLobais.aviso<=0:
			self.disabled = true
			print("jamanta")
			label.text = "voce n possui avisos"
	if nivel >= 5:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if VariaveisGLobais.aviso==0:
			self.disabled = true
			label.text = "voce n possui avisos"
	else:
		if VariaveisGLobais.dinheiro_total>=(nivel*15):
			VariaveisGLobais.aviso-=1
			print(VariaveisGLobais.aviso)
			VariaveisGLobais.dinheiro_total -= (nivel * 15)
			nivel+=1
			if nivel >= 5:
				self.disabled = true
				label.text = "BLOQUEADO"
			else:
				label.text = "tira um strike!\nvoce pode comprar esse upgrade " + str(6-nivel)+" veses\npreço do atual do upgrade: $" +str(nivel*15)
		else:
			label.text ="voce não possui dinheiro suficiente"
