extends TextureButton
@onready var painel = $"../../Control2"
@onready var label: Label = $"../../Control2/TextureRect/Label"

func _ready():
	painel.visible = false

func _on_mouse_entered() -> void:
	painel.visible = true
	label.text = "abaixa a cota diaria"

func _on_mouse_exited() -> void:
	painel.visible = false

func _on_pressed() -> void:
	pass
