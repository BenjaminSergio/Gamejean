extends TextureButton
@onready var label: Label = $"../../Control2/TextureRect/Label"
@onready var painel = $"../../Control2"

func _ready():
	painel.visible = false
	
func _on_mouse_entered() -> void:
	painel.visible = !painel.visible
	label.text = "almenta o time!"

func _on_mouse_exited() -> void:
	painel.visible = !painel.visible


func _on_pressed() -> void:
	pass # Replace with function body.
