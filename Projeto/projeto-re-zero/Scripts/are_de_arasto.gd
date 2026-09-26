extends StaticBody2D


func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	visible = false


func _process(_delta: float) -> void:
	visible = Gobla.carta_sendo_arrastada != null
