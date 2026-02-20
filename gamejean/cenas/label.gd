extends Label
@onready var label = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text="cota:"+str(VariaveisGLobais.cota)



# Called every frame. 'delta' is the elapsed time since the previous frame.
