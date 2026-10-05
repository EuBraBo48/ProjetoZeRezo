extends Node2D

var draggable := false
var is_dragging := false
var is_inside_dropable := false

var body_ref: StaticBody2D = null
var offset := Vector2.ZERO
var initial_pos := Vector2.ZERO
@export var qualCArt : int
@export var battle_manager: Node3D

@export var sprite: Sprite2D
@export var per: Marker3D


var personagens: Dictionary = {

	"emilia": preload(
		"res://Scenas/modelos/perns/Npc/emiliaani.tscn"
	),

	"prisila": preload(
		"res://Scenas/modelos/perns/Npc/prisila.tscn"
	),

	"garfiel": preload(
		"res://Scenas/modelos/perns/Npc/grafil.tscn"
	),

	"ham": preload(
		"res://Scenas/modelos/perns/Npc/ham_a_ni.tscn"
	),
	"bete": preload(
		"res://Scenas/modelos/perns/Npc/bete_ani.tscn"
	),

	"hem": preload(
		"res://Scenas/modelos/perns/Npc/hem_an.tscn"
	)
}


@export var carta_inimigo : Node3D




func _ready() -> void:
	initial_pos = global_position


func _process(_delta: float) -> void:
	if Gobla.PODEJOGAR:
		if draggable and Input.is_action_just_pressed("click"):
			if Gobla.carta_sendo_arrastada != null:
				return
			Gobla.carta_sendo_arrastada = self
			is_dragging = true
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position

		if is_dragging and Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset





		if is_dragging and Input.is_action_just_released("click"):
			is_dragging = false
			Gobla.carta_sendo_arrastada = null

			var tween := get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_QUAD)

		# Está dentro do lugar correto
			if is_inside_dropable and body_ref != null:
				tween.tween_property(self, "global_position", body_ref.global_position, 0.2)
				print("sdfesfewr")
				if qualCArt == 1:
					var coisa1 = Gobla.cart1["nome"]
					Gobla.personagem_jogado = coisa1
					COLOCARPer(coisa1)
					Gobla.PODEJOGAR = false
					queue_free() # <-- DESTROI SOMENTE ESSA CARTA
					return

				elif qualCArt == 2:
					var coisa2 = Gobla.cart2["nome"]
					Gobla.personagem_jogado = coisa2
					COLOCARPer(coisa2)
					Gobla.PODEJOGAR = false
					queue_free() # <-- DESTROI SOMENTE ESSA CARTA
					return

				elif qualCArt == 3:
					var coisa3 = Gobla.cart3["nome"]
					Gobla.personagem_jogado = coisa3
					COLOCARPer(coisa3)
					Gobla.PODEJOGAR = false
					queue_free() # <-- DESTROI SOMENTE ESSA CARTA
					return


		# Está fora
			else:
				tween.tween_property(
				self,
				"global_position",
				initial_pos,
				0.2
			)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body
		body.modulate = Color(Color.REBECCA_PURPLE, 1.0)



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body_ref = null
		body.modulate = Color(Color.REBECCA_PURPLE, 0.7)



func _on_area_2d_mouse_entered() -> void:
	if Gobla.carta_sendo_arrastada == null and Gobla.PODEJOGAR:
		draggable = true
		scale = Vector2(0.6, 0.6)



func _on_area_2d_mouse_exited() -> void:
	if not is_dragging and Gobla.PODEJOGAR:
		draggable = false
		scale = Vector2(0.5,0.5)

func COLOCARPer(nome_personagem: String) -> void:
	# ==================================================
	# VERIFICA PERSONAGEM
	# ==================================================

	if not personagens.has(
		nome_personagem
	):

		print(
			"PERSONAGEM NÃO EXISTE: ",
			nome_personagem
		)

		return


	# ==================================================
	# SALVA PERSONAGEM
	# ==================================================

	Gobla.personagem_player = nome_personagem

	Gobla.PODEJOGAR = false


	print("========================")
	print("PERSONAGEM ESCOLHIDO")
	print(nome_personagem)
	print("========================")


	# ==================================================
	# PEGA CENA
	# ==================================================

	var cena_personagem = personagens[
		nome_personagem
	]


	# ==================================================
	# CRIA PLAYER
	# ==================================================

	var PerLo = cena_personagem.instantiate()


	per.add_child(
		PerLo
	)


	# ==================================================
	# PEGA BATTLE MANAGER
	# ==================================================

	var manager = get_tree().get_first_node_in_group(
		"battle_manager"
	)


	if manager == null:

		print(
			"ERRO: BattleManager não encontrado!"
		)

		return


	battle_manager = manager


	# ==================================================
	# CONECTA PLAYER
	# ==================================================

	battle_manager.carta_player = PerLo


	battle_manager.habilidades_player = (
		PerLo.hud_de_porde
	)


	PerLo.hud_de_porde.habilidadeDoPlayer = (
		PerLo
	)


	PerLo.hud_de_porde.battle_manager = (
		battle_manager
	)


	# ==================================================
	# INIMIGO
	# ==================================================

	if carta_inimigo != null:

		battle_manager.carta_inimigo = (
			carta_inimigo
		)


	# ==================================================
	# PRIMEIRA BATALHA
	# ==================================================

	if not battle_manager.batalha_iniciada:

		battle_manager.iniciar_batalha()


	# ==================================================
	# NOVO PLAYER DEPOIS DA MORTE
	# ==================================================

	else:

		battle_manager.continuar_com_novo_player(
			PerLo
		)
