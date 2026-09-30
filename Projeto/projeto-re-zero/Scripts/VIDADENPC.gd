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
			{"nome": "Cristal de Gelo", "dano": 15},
			{"nome": "Lança de Gelo", "dano": 25},
			{"nome": "Al Huma", "dano": 40}
		]
	},

	"prisila": {
		"nome": "Prisila",
		"vida": 120,
		"vida_maxima": 120,
		"habilidades": [
			{"nome": "Corte de Espada", "dano": 20},
			{"nome": "Yang Magic", "dano": 30},
			{"nome": "Sol Carmesim", "dano": 50}
		]
	},

	"grafil": {
		"nome": "Garfiel",
		"vida": 130,
		"vida_maxima": 130,
		"habilidades": [
			{"nome": "Soco de Ferro", "dano": 20},
			{"nome": "Golpe Bestial", "dano": 35},
			{"nome": "Transformação Tigre", "dano": 55}
		]
	},

	"ham": {
		"nome": "Ham",
		"vida": 140,
		"vida_maxima": 140,
		"habilidades": [
			{"nome": "Mordida", "dano": 25},
			{"nome": "Investida", "dano": 40},
			{"nome": "Ataque Selvagem", "dano": 55}
		]
	},

	"hem": {
		"nome": "Hem",
		"vida": 110,
		"vida_maxima": 110,
		"habilidades": [
			{"nome": "Rajada de Vento", "dano": 15},
			{"nome": "Al Wind", "dano": 30},
			{"nome": "Força de Oni", "dano": 45}

		]
	},

	"bete": {
		"nome": "Bete",
		"vida": 90,
		"vida_maxima": 90,
		"habilidades": [
			{"nome": "Magia", "dano": 20},
			{"nome": "Explosão", "dano": 35},
			{"nome": "Especial", "dano": 50}
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

	# ==================================================
	# PERSONAGEM ESCOLHIDO
	# ==================================================

	var nome_personagem: String = (
		Gobla.personagem_player
	)


	# ==================================================
	# PEGA A CARTA
	# ==================================================

	if (
		nome_personagem != ""
		and cartas.has(nome_personagem)
	):

		carta = cartas[
			nome_personagem
		].duplicate(true)

	else:

		carta = cartas[
			"emilia"
		].duplicate(true)


	# ==================================================
	# APLICA POWER HP
	# ==================================================

	var nivel_vida = get_nivel_vida()

	var bonus_vida = bonus_por_nivel(
		nivel_vida
	)

	carta["vida_maxima"] += bonus_vida

	carta["vida"] = carta["vida_maxima"]


	# ==================================================
	# APLICA POWER DMG
	# ==================================================

	var nivel_dano = get_nivel_dano()

	var bonus_dano = bonus_por_nivel(
		nivel_dano
	)


	for habilidade in carta["habilidades"]:

		# Não transforma habilidade de dano 0
		# em ataque só por causa do upgrade
		if habilidade["dano"] > 0:

			habilidade["dano"] += bonus_dano


	# ==================================================
	# SALVA A CARTA ATUAL
	# ==================================================

	Gobla.carta_player = carta


	print("========================")
	print("PLAYER CRIADO")
	print("Personagem: ", carta["nome"])
	print("Vida: ", carta["vida"])
	print("========================")


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


	animation_player.stop()


	# mixamo_com = parado
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


	animation_player.stop()


	# mixamo_com_001 = ataque
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


	Gobla.carta_player = carta


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


# ==================================================
# PEGAR NÍVEL DE VIDA
# ==================================================

func get_nivel_vida() -> int:

	var nome = Gobla.personagem_player


	if (
		Gobla.cart1.has("nome")
		and Gobla.cart1["nome"] == nome
	):

		return Gobla.vidaDaCart1


	if (
		Gobla.cart2.has("nome")
		and Gobla.cart2["nome"] == nome
	):

		return Gobla.vidaDaCart2


	if (
		Gobla.cart3.has("nome")
		and Gobla.cart3["nome"] == nome
	):

		return Gobla.vidaDaCart3


	return 0


# ==================================================
# PEGAR NÍVEL DE DANO
# ==================================================

func get_nivel_dano() -> int:

	var nome = Gobla.personagem_player


	if (
		Gobla.cart1.has("nome")
		and Gobla.cart1["nome"] == nome
	):

		return Gobla.DanoDaCart1


	if (
		Gobla.cart2.has("nome")
		and Gobla.cart2["nome"] == nome
	):

		return Gobla.DanoDaCart2


	if (
		Gobla.cart3.has("nome")
		and Gobla.cart3["nome"] == nome
	):

		return Gobla.DanoDaCart3


	return 0


# ==================================================
# BÔNUS POR NÍVEL
# ==================================================

func bonus_por_nivel(
	nivel: int
) -> int:

	if nivel == 1:

		return 20

	elif nivel == 2:

		return 30

	elif nivel >= 3:

		return 40


	return 0
