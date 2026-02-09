extends TextureButton
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var painel = $"../../Control2"
@onready var nivel: int =1
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
