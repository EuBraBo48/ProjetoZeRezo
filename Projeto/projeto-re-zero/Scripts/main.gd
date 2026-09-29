extends Node3D

@export var player: CharacterBody3D


func _ready() -> void:
	player.position = Gobla.posicaoPlay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
