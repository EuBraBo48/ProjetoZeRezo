extends Node3D


# ==================================================
# TURNOS
# ==================================================

enum Turno {

	PLAYER,

	IA,

	FIM
}


# ==================================================
# REFERÊNCIAS
# ==================================================

@export var carta_player: Node3D
@export var carta_inimigo: Node3D
@export var habilidades_player: Control


# ==================================================
# LABELS
# ==================================================

@export var label_round: Label
@export var label_vez: Label


# ==================================================
# ESTADO
# ==================================================

var turno_atual: Turno = Turno.FIM

var batalha_terminou := false

var vitorias_player := 0
var vitorias_ia := 0

var batalha_iniciada := false

var round_atual := 1


# ==================================================
# RESULTADO
# ==================================================

var resultado_final: String = ""

signal batalha_finalizada(
	vencedor: String
)


# ==================================================
# READY
# ==================================================

func _ready() -> void:

	print(
		"BattleManager pronto."
	)

	atualizar_label_round()

	if label_vez:

		label_vez.text = "AGUARDANDO..."


# ==================================================
# ROUND
# ==================================================

func atualizar_label_round() -> void:

	if label_round == null:
		return

	label_round.text = (
		"Round "
		+ str(round_atual)
	)


# ==================================================
# PLAYER
# ==================================================

func mostrar_vez_player() -> void:

	if label_vez == null:
		return

	label_vez.text = "SUA VEZ"


# ==================================================
# IA
# ==================================================

func mostrar_vez_ia() -> void:

	if label_vez == null:
		return

	label_vez.text = "VEZ DA IA"


# ==================================================
# INICIAR BATALHA
# ==================================================

func iniciar_batalha() -> void:

	if batalha_iniciada:
		return


	if carta_player == null:

		print(
			"Ainda não existe carta do PLAYER!"
		)

		return


	if carta_inimigo == null:

		print(
			"Ainda não existe carta do INIMIGO!"
		)

		return


	if habilidades_player == null:

		print(
			"Ainda não existe HUD do PLAYER!"
		)

		return


	batalha_iniciada = true
	batalha_terminou = false

	vitorias_player = 0
	vitorias_ia = 0

	round_atual = 1

	resultado_final = ""

	atualizar_label_round()


	print("========================")
	print("      BATALHA INICIOU")
	print("========================")


	iniciar_turno_player()


# ==================================================
# NOVO PLAYER
# ==================================================

func continuar_com_novo_player(
	novo_player: Node3D
) -> void:

	carta_player = novo_player

	batalha_terminou = false

	turno_atual = Turno.FIM


	if is_instance_valid(
		carta_player
	):

		if carta_player.has_method(
			"tocar_idle"
		):

			carta_player.tocar_idle()


	await get_tree().create_timer(
		0.2
	).timeout


	iniciar_turno_player()


# ==================================================
# TURNO PLAYER
# ==================================================

func iniciar_turno_player() -> void:

	if batalha_terminou:
		return


	if not is_instance_valid(
		carta_player
	):

		return


	if not is_instance_valid(
		carta_inimigo
	):

		return


	turno_atual = Turno.PLAYER


	print("========================")
	print("     TURNO PLAYER")
	print("========================")


	mostrar_vez_player()

	habilidades_player.liberar_jogador()


# ==================================================
# PLAYER ESCOLHE
# ==================================================

func jogador_usou_habilidade(
	habilidade: Dictionary
) -> void:

	if batalha_terminou:
		return


	if turno_atual != Turno.PLAYER:
		return


	if not is_instance_valid(
		carta_player
	):

		return


	print(
		"PLAYER ESCOLHEU: ",
		habilidade["nome"]
	)


	habilidades_player.bloquear_jogador()


	await atacar_player(
		habilidade
	)


	if await verificar_morte():
		return


	await get_tree().create_timer(
		0.5
	).timeout


	iniciar_turno_ia()


# ==================================================
# ATAQUE PLAYER
# ==================================================

func atacar_player(
	habilidade: Dictionary
) -> void:

	print(
		"PLAYER ATACANDO!"
	)


	if carta_player.animation_player:

		await carta_player.atacar_animacao()


	# O dano já vem com o PowerDMG aplicado
	var dano = habilidade[
		"dano"
	]


	print(
		"PLAYER USOU: ",
		habilidade["nome"]
	)


	print(
		"PLAYER CAUSOU: ",
		dano
	)


	carta_inimigo.receber_dano(
		dano
	)


	await get_tree().create_timer(
		0.5
	).timeout


# ==================================================
# TURNO IA
# ==================================================

func iniciar_turno_ia() -> void:

	if batalha_terminou:
		return


	if not is_instance_valid(
		carta_player
	):

		return


	if not is_instance_valid(
		carta_inimigo
	):

		return


	turno_atual = Turno.IA


	print("========================")
	print("       TURNO IA")
	print("========================")


	mostrar_vez_ia()


	await get_tree().create_timer(
		0.7
	).timeout


	var habilidade = await carta_inimigo.jogar()


	await atacar_ia(
		habilidade
	)


	if await verificar_morte():
		return


	await get_tree().create_timer(
		0.5
	).timeout


	iniciar_turno_player()


# ==================================================
# ATAQUE IA
# ==================================================

func atacar_ia(
	habilidade: Dictionary
) -> void:

	print(
		"IA USOU: ",
		habilidade["nome"]
	)


	await carta_inimigo.atacar()


	var dano = habilidade[
		"dano"
	]


	print(
		"IA CAUSOU: ",
		dano
	)


	carta_player.receber_dano(
		dano
	)


	await get_tree().create_timer(
		0.5
	).timeout


# ==================================================
# VERIFICAR MORTE
# ==================================================

func verificar_morte() -> bool:


	# ==================================================
	# INIMIGO MORREU
	# ==================================================

	if carta_inimigo.morreu():

		vitorias_player += 1


		if round_atual >= 3:

			finalizar_partida()

			return true


		round_atual += 1

		atualizar_label_round()


		await get_tree().create_timer(
			1.0
		).timeout


		carta_inimigo.trocar_personagem()


		# Player mantém a vida
		iniciar_turno_player()


		return true


	# ==================================================
	# PLAYER MORREU
	# ==================================================

	if carta_player.morreu():

		vitorias_ia += 1

		Gobla.Mortes += 1


		if is_instance_valid(
			habilidades_player
		):

			habilidades_player.bloquear_jogador()


		Gobla.PODEJOGAR = true


		if round_atual >= 3:

			if is_instance_valid(
				carta_player
			):

				carta_player.queue_free()


			carta_player = null

			finalizar_partida()

			return true


		round_atual += 1

		atualizar_label_round()


		if is_instance_valid(
			carta_player
		):

			carta_player.queue_free()


		carta_player = null


		batalha_terminou = true

		turno_atual = Turno.FIM


		return true


	return false


# ==================================================
# FINALIZAR PARTIDA
# ==================================================

func finalizar_partida() -> void:

	batalha_terminou = true

	turno_atual = Turno.FIM


	print("========================")
	print("     FIM DA PARTIDA")
	print("========================")


	print(
		"ROUNDS DO PLAYER: ",
		vitorias_player
	)


	print(
		"ROUNDS DA IA: ",
		vitorias_ia
	)


	# ==================================================
	# VENCEDOR
	# ==================================================

	if vitorias_player > vitorias_ia:

		resultado_final = "PLAYER"

	elif vitorias_ia > vitorias_player:

		resultado_final = "IA"

	else:

		resultado_final = "EMPATE"


	# ==================================================
	# LABEL
	# ==================================================

	if label_vez:

		if resultado_final == "PLAYER":

			label_vez.text = "VOCÊ VENCEU!"

			Gobla.Vitoria += 1
			Gobla.PontoDePar += 30

		elif resultado_final == "IA":

			label_vez.text = "IA VENCEU!"

		else:

			label_vez.text = "EMPATE!"


	# ==================================================
	# SINAL
	# ==================================================

	batalha_finalizada.emit(
		resultado_final
	)


	# ==================================================
	# FUNÇÃO FUTURA
	# ==================================================

	funcao_futura_fim_da_batalha(
		resultado_final
	)


# ==================================================
# FUNÇÃO FUTURA
# ==================================================

func funcao_futura_fim_da_batalha(
	vencedor: String
) -> void:

	pass
