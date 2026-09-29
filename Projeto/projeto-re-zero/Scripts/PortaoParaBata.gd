extends Node3D

var estNA:= false
@export var CAminho: PackedScene
@export var player : CharacterBody3D

func _process(delta: float) -> void:
	if estNA and Input.is_action_pressed("interagir"):
		Gobla.InimeDaCena = CAminho
		Gobla.posicaoPlay = player.position
		get_tree().change_scene_to_file("res://Scenas/batalha.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("dfshifiusf")
		estNA = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		estNA = false
