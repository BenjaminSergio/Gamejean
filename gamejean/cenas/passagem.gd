extends TextureButton
@onready var painel = $"../../Control2"
@onready var label: Label = $"../../Control2/TextureRect/Label"
#nivel |preço
#1     | 10
#2     | 20
#3     | 30
#4     | 40
#10 max | 100

@onready var nivel: int =1
func _ready():

	painel.visible = false
@export var son_upgrade: AudioStream
@export var son_jamanta: AudioStream
func _on_mouse_entered() -> void:
	painel.visible = !painel.visible # Replace with function body.
	label.text = "aumenta o preço pago da passagem dos alunos"
	if nivel >= 10:
		label.text = "BLOQUEADO"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	if nivel>=10:
			print("jamanta")
			AudioManager.play_sfx(son_jamanta)
			return
	if VariaveisGLobais.dinheiro_total>=(nivel*10):
		print(nivel)
		nivel+=1
		VariaveisGLobais.dinheiro_total -= (nivel * 10)
		VariaveisGLobais.preco_passagem=VariaveisGLobais.preco_passagem+(nivel * 0.25)
		print(VariaveisGLobais.preco_passagem)
		
		if nivel >= 11:
			self.disabled = true
			label.text = "BLOQUEADO"
			AudioManager.play_sfx(son_jamanta)
			return
		AudioManager.play_sfx(son_upgrade)
		
