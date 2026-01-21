extends TextureButton
@onready var painel = $"../../Control2"
@onready var label: Label = $"../../Control2/TextureRect/Label"
func _ready():
	painel.visible = false


func _on_mouse_entered() -> void:
	painel.visible = !painel.visible # Replace with function body.
	label.text = "aumenta o preço pago da passagem dos alunos"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	pass
