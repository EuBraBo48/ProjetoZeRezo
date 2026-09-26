extends Control

@export var habilidadeDoPlayer: Node3D
var pode_jogar := false


func _on_button_pressed() -> void:
	if self.visible == true:
		self.hide()
	else:
		self.show()


func _on_bh_1_pressed() -> void:
	var dano = habilidadeDoPlayer.carta["habilidades"][1]["dano"]
	habilidadeDoPlayer.animation_player.play("mixamo_com")
	await get_tree().create_timer(2.4).timeout
	habilidadeDoPlayer.animation_player.play("mixamo_com_001")
	#


func _on_bh_2_pressed() -> void:
	pass # Replace with function body.


func _on_bh_3_pressed() -> void:
	pass # Replace with function body.
