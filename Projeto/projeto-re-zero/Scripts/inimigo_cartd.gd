extends Node3D


# ==================================================
# PERSONAGENS / CARTAS DA IA
# ==================================================

var personagens: Dictionary = {

	"bete": {

		"cena": preload(
			"res://Scenas/modelos/perns/NpcRuin/bete_aniRuin.tscn"
		),

		"carta": {

			"nome": "Bete",
			"vida": 90,
			"vida_maxima": 90,

			"habilidades": [

				{
					"nome": "Magia",
					"dano": 20
				},

				{
					"nome": "Explosão",
					"dano": 35
				},

				{
					"nome": "Especial",
					"dano": 50
				}
			]
		}
	},


	"emilia": {

		"cena": preload(
			"res://Scenas/modelos/perns/NpcRuin/emiliaaniRuin.tscn"
		),

		"carta": {

			"nome": "Emilia",
			"vida": 100,
			"vida_maxima": 100,

			"habilidades": [

				{
					"nome": "Gelo",
					"dano": 15
				},

				{
					"nome": "Barreira",
					"dano": 25
				},

				{
					"nome": "Magia de Gelo",
					"dano": 40
				}
			]
		}
	},


	"grafil": {

		"cena": preload(
			"res://Scenas/modelos/perns/NpcRuin/grafilRuin.tscn"
		),

		"carta": {

			"nome": "Garfiel",
			"vida": 130,
			"vida_maxima": 130,

			"habilidades": [

				{
					"nome": "Soco",
					"dano": 20
				},

				{
					"nome": "Soco Forte",
					"dano": 35
				},

				{
					"nome": "Especial",
					"dano": 50
				}
			]
		}
	},


	"ham": {

		"cena": preload(
			"res://Scenas/modelos/perns/NpcRuin/ham_a_niRuin.tscn"
		),

		"carta": {

			"nome": "Ham",
			"vida": 140,
			"vida_maxima": 140,

			"habilidades": [

				{
					"nome": "Mordida",
					"dano": 25
				},

				{
					"nome": "Investida",
					"dano": 40
				},

				{
					"nome": "Especial",
					"dano": 55
				}
			]
		}
	},


	"hem": {

		"cena": preload(
			"res://Scenas/modelos/perns/NpcRuin/hem_anRuin.tscn"
		),

		"carta": {

			"nome": "Hem",
			"vida": 110,
			"vida_maxima": 110,

			"habilidades": [

				{
					"nome": "Ataque",
					"dano": 15
				},

				{
					"nome": "Ataque Forte",
					"dano": 30
				},

				{
					"nome": "Especial",
					"dano": 45
				}
			]
		}
	},


	"prisila": {

		"cena": preload(
			"res://Scenas/modelos/perns/NpcRuin/prisilaRuin.tscn"
		),

		"carta": {

			"nome": "Prisila",
			"vida": 120,
			"vida_maxima": 120,

			"habilidades": [

				{
					"nome": "Corte",
					"dano": 20
				},

				{
					"nome": "Ataque Poderoso",
					"dano": 35
				},

				{
					"nome": "Especial",
					"dano": 50
				}
			]
		}
	}
}


# ==================================================
# PERSONAGENS JÁ USADOS
# ==================================================

var personagens_usados: Array = []


# ==================================================
# CARTA ATUAL
# ==================================================

var carta: Dictionary = {}


# ==================================================
# PERSONAGEM ATUAL
# ==================================================

var personagem: Node3D = null
var animation_player: AnimationPlayer = null


# ==================================================
# LABEL DO DANO DO INIMIGO
# ==================================================

var label_dano_inimigo: Label


# ==================================================
# READY
# ==================================================

func _ready() -> void:

	criar_novo_personagem()


# ==================================================
# CRIAR LABEL DO DANO
# ==================================================

func criar_label_dano() -> void:

	label_dano_inimigo = Label.new()

	label_dano_inimigo.text = "-0"
	label_dano_inimigo.visible = false

	label_dano_inimigo.z_index = 100

	label_dano_inimigo.add_theme_font_size_override(
		"font_size",
		40
	)

	label_dano_inimigo.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	label_dano_inimigo.add_theme_color_override(
		"font_shadow_color",
		Color.BLACK
	)

	label_dano_inimigo.add_theme_constant_override(
		"shadow_offset_x",
		3
	)

	label_dano_inimigo.add_theme_constant_override(
		"shadow_offset_y",
		3
	)

	get_tree().root.add_child(
		label_dano_inimigo
	)


# ==================================================
# CRIAR PERSONAGEM
# ==================================================

func criar_novo_personagem() -> void:

	if personagens_usados.size() >= personagens.size():

		personagens_usados.clear()


	var disponiveis: Array = []


	for nome_personagem in personagens.keys():

		if not personagens_usados.has(
			nome_personagem
		):

			disponiveis.append(
				nome_personagem
			)


	var nome_escolhido: String = (
		disponiveis.pick_random()
	)


	personagens_usados.append(
		nome_escolhido
	)


	var dados = personagens[
		nome_escolhido
	]


	# ==================================================
	# PEGA A CARTA
	# ==================================================

	carta = dados[
		"carta"
	].duplicate(true)

	carta["vida"] = carta[
		"vida_maxima"
	]


	# ==================================================
	# INSTANTIA PERSONAGEM
	# ==================================================

	personagem = dados[
		"cena"
	].instantiate()

	add_child(
		personagem
	)


	# ==================================================
	# ANIMATION PLAYER
	# ==================================================

	animation_player = personagem.find_child(
		"AnimationPlayer",
		true,
		false
	)


	if animation_player:

		print(
			"AnimationPlayer do inimigo encontrado!"
		)

	else:

		print(
			"AnimationPlayer do inimigo NÃO encontrado!"
		)


	# ==================================================
	# PRINT
	# ==================================================

	print("========================")
	print("NOVO INIMIGO")
	print("Personagem: ", carta["nome"])
	print("Vida: ", carta["vida"])
	print("========================")


	# ==================================================
	# CRIA LABEL
	# ==================================================

	criar_label_dano()


	# ==================================================
	# IDLE
	# ==================================================

	tocar_idle()


# ==================================================
# IDLE
# ==================================================

func tocar_idle() -> void:

	if animation_player == null:
		return

	animation_player.stop()

	if animation_player.has_animation(
		"mixamo_com"
	):

		animation_player.play(
			"mixamo_com"
		)


# ==================================================
# IA ESCOLHE HABILIDADE
# ==================================================

func jogar() -> Dictionary:

	print(
		"IA está pensando..."
	)

	await get_tree().create_timer(
		1.0
	).timeout

	var habilidade = carta[
		"habilidades"
	].pick_random()

	print(
		"IA escolheu: ",
		habilidade["nome"]
	)

	return habilidade


# ==================================================
# ATAQUE
# ==================================================

func atacar() -> void:

	if animation_player == null:

		print(
			"IA não possui AnimationPlayer!"
		)

		return

	animation_player.stop()

	if animation_player.has_animation(
		"mixamo_com_001"
	):

		animation_player.play(
			"mixamo_com_001"
		)

		await get_tree().create_timer(
			2.4
		).timeout

	tocar_idle()


# ==================================================
# RECEBER DANO
# ==================================================

func receber_dano(
	dano: int
) -> void:

	carta["vida"] -= dano

	carta["vida"] = max(
		carta["vida"],
		0
	)

	print("========================")
	print("IA RECEBEU DANO")
	print("Personagem: ", carta["nome"])
	print("Dano: ", dano)

	print(
		"Vida: ",
		carta["vida"],
		"/",
		carta["vida_maxima"]
	)

	print("========================")

	# MOSTRA O DANO QUE O INIMIGO RECEBEU
	mostrar_dano_inimigo(
		dano
	)


# ==================================================
# MOSTRAR DANO DO INIMIGO
# ==================================================
func mostrar_dano_inimigo(dano: int) -> void:

	if label_dano_inimigo == null:
		print("ERRO: LABEL DE DANO DO INIMIGO NÃO EXISTE!")
		return

	label_dano_inimigo.text = "-" + str(dano)
	label_dano_inimigo.visible = true
	label_dano_inimigo.modulate.a = 1.0

	# PROCURA O BATTLE MANAGER
	var battle_manager = get_tree().get_first_node_in_group("battle_manager")

	if battle_manager == null:
		print("ERRO: BattleManager não encontrado!")
		return

	# PEGA O PLAYER
	var player = battle_manager.carta_player

	if not is_instance_valid(player):
		print("ERRO: Player não existe!")
		return

	var camera = get_viewport().get_camera_3d()

	if camera == null:
		print("ERRO: Câmera 3D não encontrada!")
		return

	# POSIÇÃO DO PLAYER
	var pos_3d = player.global_position

	# SOBE O TEXTO
	pos_3d.y += 2.0

	# CONVERTE PARA POSIÇÃO NA TELA
	var pos_tela = camera.unproject_position(pos_3d)

	label_dano_inimigo.position = pos_tela

	print(
		"DANO DA IA APARECENDO NO PLAYER: -",
		dano
	)

	var pos_inicial = label_dano_inimigo.position
	var pos_final = pos_inicial + Vector2(0, -60)

	var tween = get_tree().create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		label_dano_inimigo,
		"position",
		pos_final,
		1.0
	)

	tween.tween_property(
		label_dano_inimigo,
		"modulate:a",
		0.0,
		1.0
	)

	await tween.finished

	label_dano_inimigo.visible = false
	label_dano_inimigo.modulate.a = 1.0

# ==================================================
# MORTE
# ==================================================

func morreu() -> bool:

	return carta["vida"] <= 0


# ==================================================
# TROCAR PERSONAGEM
# ==================================================

func trocar_personagem() -> void:

	print(
		"TROCANDO PERSONAGEM DO INIMIGO"
	)


	# ==================================================
	# APAGA LABEL ANTIGO
	# ==================================================

	if is_instance_valid(
		label_dano_inimigo
	):

		label_dano_inimigo.queue_free()

		label_dano_inimigo = null


	# ==================================================
	# APAGA PERSONAGEM ANTIGO
	# ==================================================

	if is_instance_valid(
		personagem
	):

		personagem.queue_free()


	personagem = null
	animation_player = null


	# ==================================================
	# CRIA NOVO
	# ==================================================

	criar_novo_personagem()
