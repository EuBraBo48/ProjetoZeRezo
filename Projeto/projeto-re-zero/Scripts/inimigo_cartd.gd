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
# READY
# ==================================================

func _ready() -> void:

	criar_novo_personagem()


# ==================================================
# CRIAR PERSONAGEM
# ==================================================

func criar_novo_personagem() -> void:

	# Todos já apareceram
	if personagens_usados.size() >= personagens.size():

		personagens_usados.clear()


	# Disponíveis
	var disponiveis: Array = []


	for nome_personagem in personagens.keys():

		if not personagens_usados.has(
			nome_personagem
		):

			disponiveis.append(
				nome_personagem
			)


	# Escolhe personagem
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
	# PEGA A CARTA DESTE PERSONAGEM
	# ==================================================

	carta = dados[
		"carta"
	].duplicate(true)


	# Vida cheia
	carta["vida"] = carta[
		"vida_maxima"
	]


	# ==================================================
	# INSTANTIA O PERSONAGEM
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
	# PRINT DA CARTA
	# ==================================================

	print("========================")
	print("NOVO INIMIGO")
	print("Personagem: ", carta["nome"])
	print("Vida: ", carta["vida"])
	print("========================")


	# Começa parado
	tocar_idle()


# ==================================================
# IDLE / PARADO
# ==================================================

func tocar_idle() -> void:

	if animation_player == null:
		return


	animation_player.stop()


	# mixamo_com = PARADO
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


	# Escolhe UMA das 3 habilidades
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


	# mixamo_com_001 = ATAQUE
	if animation_player.has_animation(
		"mixamo_com_001"
	):

		animation_player.play(
			"mixamo_com_001"
		)


		await get_tree().create_timer(
			2.4
		).timeout


	# Volta para Idle
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


	if is_instance_valid(
		personagem
	):

		personagem.queue_free()


	personagem = null

	animation_player = null


	# Novo personagem
	criar_novo_personagem()
