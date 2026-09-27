extends Node3D


# ==================================================
# HUD
# ==================================================

@export var hud_de_porde: Control


# ==================================================
# CARTAS DOS PERSONAGENS
# ==================================================

var cartas: Dictionary = {

	"emilia": {

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
				"dano": 0
			},

			{
				"nome": "Magia de Gelo",
				"dano": 30
			}
		]
	},


	"prisila": {

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
	},


	"grafil": {

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
	},


	"ham": {

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
	},


	"hem": {

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
}


# ==================================================
# CARTA ATUAL DO PLAYER
# ==================================================

var carta: Dictionary = {}


# ==================================================
# ANIMAÇÃO
# ==================================================

var animation_player: AnimationPlayer = null


# ==================================================
# SINAL DA VIDA
# ==================================================

signal vida_mudou(
	vida_atual: int,
	vida_maxima: int
)


# ==================================================
# READY
# ==================================================

func _ready() -> void:

	# Pega o personagem escolhido na Gobla
	var nome_personagem: String = (
		Gobla.personagem_player
	)


	# ==================================================
	# PEGA A CARTA DO PERSONAGEM
	# ==================================================

	if (
		nome_personagem != ""
		and cartas.has(nome_personagem)
	):

		carta = cartas[
			nome_personagem
		].duplicate(true)


	else:

		# Segurança
		carta = cartas[
			"emilia"
		].duplicate(true)


	# ==================================================
	# NOVO PERSONAGEM COMEÇA COM VIDA CHEIA
	# ==================================================

	carta["vida"] = carta[
		"vida_maxima"
	]


	# Salva a carta atual
	Gobla.carta_player = carta


	print("========================")
	print("PLAYER CRIADO")
	print("Personagem: ", carta["nome"])
	print("Vida: ", carta["vida"])
	print("========================")

	print("HABILIDADES DO PLAYER:")

	for habilidade in carta["habilidades"]:

		print(
			habilidade["nome"],
			" - Dano: ",
			habilidade["dano"]
		)


	# ==================================================
	# ANIMATION PLAYER
	# ==================================================

	animation_player = find_child(
		"AnimationPlayer",
		true,
		false
	)


	if animation_player:

		print(
			"AnimationPlayer do Player encontrado!"
		)

	else:

		print(
			"AnimationPlayer do Player NÃO encontrado!"
		)


	# Começa parado
	tocar_idle()


	# Atualiza vida
	vida_mudou.emit(
		carta["vida"],
		carta["vida_maxima"]
	)


# ==================================================
# IDLE / PARADO
# ==================================================

func tocar_idle() -> void:

	if animation_player == null:
		return


	# mixamo_com = PARADO
	animation_player.stop()


	if animation_player.has_animation(
		"mixamo_com"
	):

		animation_player.play(
			"mixamo_com"
		)


# ==================================================
# ATAQUE
# ==================================================

func atacar_animacao() -> void:

	if animation_player == null:

		print(
			"Player não possui AnimationPlayer!"
		)

		return


	# Para o Idle
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


	# Atualiza Gobla
	Gobla.carta_player = carta


	# Atualiza ProgressBar
	vida_mudou.emit(
		carta["vida"],
		carta["vida_maxima"]
	)


	print("========================")
	print("PLAYER RECEBEU DANO")
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
# RESETAR VIDA
# ==================================================

func resetar_vida() -> void:

	carta["vida"] = carta[
		"vida_maxima"
	]


	Gobla.carta_player = carta


	vida_mudou.emit(
		carta["vida"],
		carta["vida_maxima"]
	)


	print(
		"Vida PLAYER resetada para ",
		carta["vida"]
	)
