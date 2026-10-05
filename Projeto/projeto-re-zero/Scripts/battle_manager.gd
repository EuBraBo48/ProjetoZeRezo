extends Node3D

enum Turno {
	PLAYER,
	IA,
	FIM
}

@export var carta_player: Node3D
@export var carta_inimigo: Node3D
@export var habilidades_player: Control

@export var label_round: Label
@export var label_vez: Label

# ==================================================
# LABELS DE DANO
# ==================================================

# Label que fica perto do PLAYER
@export var label_dano_player: Label

# Label que fica perto da IA
@export var label_dano_inimigo: Label


var turno_atual: Turno = Turno.FIM
var batalha_terminou := false

var vitorias_player := 0
var vitorias_ia := 0

var batalha_iniciada := false
var round_atual := 1

var resultado_final: String = ""

signal batalha_finalizada(vencedor: String)


func _ready() -> void:

	print("BattleManager pronto.")

	atualizar_label_round()

	# Esconde os dois Labels no começo
	if label_dano_player:
		label_dano_player.visible = false

	if label_dano_inimigo:
		label_dano_inimigo.visible = false

	if label_vez:
		label_vez.text = "AGUARDANDO..."


# ==================================================
# ROUND
# ==================================================

func atualizar_label_round() -> void:

	if label_round == null:
		return

	label_round.text = "Round " + str(round_atual)


# ==================================================
# VEZ DO PLAYER
# ==================================================

func mostrar_vez_player() -> void:

	if label_vez == null:
		return

	label_vez.text = "SUA VEZ"


# ==================================================
# VEZ DA IA
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
		print("Ainda não existe carta do PLAYER!")
		return

	if carta_inimigo == null:
		print("Ainda não existe carta do INIMIGO!")
		return

	if habilidades_player == null:
		print("Ainda não existe HUD do PLAYER!")
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

func continuar_com_novo_player(novo_player: Node3D) -> void:

	carta_player = novo_player

	batalha_terminou = false
	turno_atual = Turno.FIM

	if is_instance_valid(carta_player):

		if carta_player.has_method("tocar_idle"):
			carta_player.tocar_idle()

	await get_tree().create_timer(0.2).timeout

	iniciar_turno_player()


# ==================================================
# TURNO PLAYER
# ==================================================

func iniciar_turno_player() -> void:

	if batalha_terminou:
		return

	if not is_instance_valid(carta_player):
		return

	if not is_instance_valid(carta_inimigo):
		return

	turno_atual = Turno.PLAYER

	print("========================")
	print("     TURNO PLAYER")
	print("========================")

	mostrar_vez_player()

	habilidades_player.liberar_jogador()


# ==================================================
# PLAYER ESCOLHE HABILIDADE
# ==================================================

func jogador_usou_habilidade(habilidade: Dictionary) -> void:

	if batalha_terminou:
		return

	if turno_atual != Turno.PLAYER:
		return

	if not is_instance_valid(carta_player):
		return

	print("PLAYER ESCOLHEU: ", habilidade["nome"])

	habilidades_player.bloquear_jogador()

	await atacar_player(habilidade)

	if await verificar_morte():
		return

	await get_tree().create_timer(0.5).timeout

	iniciar_turno_ia()


# ==================================================
# ATAQUE DO PLAYER
# ==================================================

func atacar_player(habilidade: Dictionary) -> void:

	print("PLAYER ATACANDO!")

	if carta_player.animation_player:
		await carta_player.atacar_animacao()

	var dano = habilidade["dano"]

	print("PLAYER USOU: ", habilidade["nome"])
	print("PLAYER CAUSOU: ", dano)

	# IA RECEBE O DANO
	carta_inimigo.receber_dano(dano)

	# MOSTRA O DANO NO LABEL DA IA
	mostrar_dano_inimigo(dano)

	await get_tree().create_timer(0.5).timeout


# ==================================================
# TURNO IA
# ==================================================

func iniciar_turno_ia() -> void:

	if batalha_terminou:
		return

	if not is_instance_valid(carta_player):
		return

	if not is_instance_valid(carta_inimigo):
		return

	turno_atual = Turno.IA

	print("========================")
	print("       TURNO IA")
	print("========================")

	mostrar_vez_ia()

	await get_tree().create_timer(0.7).timeout

	var habilidade = await carta_inimigo.jogar()

	await atacar_ia(habilidade)

	if await verificar_morte():
		return

	await get_tree().create_timer(0.5).timeout

	iniciar_turno_player()


# ==================================================
# ATAQUE DA IA
# ==================================================

func atacar_ia(habilidade: Dictionary) -> void:

	print("IA USOU: ", habilidade["nome"])

	await carta_inimigo.atacar()

	var dano = habilidade["dano"]

	print("IA CAUSOU: ", dano)

	# PLAYER RECEBE O DANO
	carta_player.receber_dano(dano)

	# MOSTRA O DANO NO LABEL DO PLAYER
	mostrar_dano_player(dano)

	await get_tree().create_timer(0.5).timeout


# ==================================================
# DANO NO INIMIGO
# ==================================================

func mostrar_dano_inimigo(dano: int) -> void:

	if label_dano_inimigo == null:
		print("ERRO: label_dano_inimigo não foi definido!")
		return

	label_dano_inimigo.text = "-" + str(dano)

	label_dano_inimigo.visible = true

	label_dano_inimigo.modulate.a = 1.0

	# Guarda a posição original
	var pos_inicial = label_dano_inimigo.position

	# Posição para onde vai subir
	var pos_final = pos_inicial + Vector2(0, -60)

	var tween = get_tree().create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		label_dano_inimigo,
		"position",
		pos_final,
		0.8
	)

	tween.tween_property(
		label_dano_inimigo,
		"modulate:a",
		0.0,
		0.8
	)

	await tween.finished

	# Volta para a posição original
	label_dano_inimigo.position = pos_inicial

	label_dano_inimigo.visible = false

	label_dano_inimigo.modulate.a = 1.0


# ==================================================
# DANO NO PLAYER
# ==================================================

func mostrar_dano_player(dano: int) -> void:
	if label_dano_player == null:
		print("ERRO: label_dano_player não foi definido!")
		return

	label_dano_player.text = "-" + str(dano)

	label_dano_player.visible = true

	label_dano_player.modulate.a = 1.0

	# Guarda a posição original
	var pos_inicial = label_dano_player.position

	# Posição para onde vai subir
	var pos_final = pos_inicial + Vector2(0, -60)

	var tween = get_tree().create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		label_dano_player,
		"position",
		pos_final,
		0.9
	)

	tween.tween_property(
		label_dano_player,
		"modulate:a",
		0.0,
		0.9
	)

	await tween.finished

	# Volta para a posição original
	label_dano_player.position = pos_inicial

	label_dano_player.visible = false

	label_dano_player.modulate.a = 1.0


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

		await get_tree().create_timer(1.0).timeout

		carta_inimigo.trocar_personagem()

		iniciar_turno_player()

		return true


	# ==================================================
	# PLAYER MORREU
	# ==================================================

	if carta_player.morreu():

		Gobla.Mortes += 20

		vitorias_ia += 1

		if is_instance_valid(habilidades_player):
			habilidades_player.bloquear_jogador()

		Gobla.PODEJOGAR = true

		if round_atual >= 3:

			if is_instance_valid(carta_player):
				carta_player.queue_free()

			carta_player = null

			finalizar_partida()

			return true

		round_atual += 1

		atualizar_label_round()

		if is_instance_valid(carta_player):
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

	print("ROUNDS DO PLAYER: ", vitorias_player)
	print("ROUNDS DA IA: ", vitorias_ia)

	if vitorias_player > vitorias_ia:

		resultado_final = "PLAYER"

	elif vitorias_ia > vitorias_player:

		resultado_final = "IA"

	else:

		resultado_final = "EMPATE"

	if label_vez:

		if resultado_final == "PLAYER":

			label_vez.text = "VOCÊ VENCEU!"
			Gobla.Vitoria += 1
			Gobla.PontoDePar += 30

		elif resultado_final == "IA":
			$"../../AudioStreamPlayer2".play()
			label_vez.text = "IA VENCEU!"

		else:
			label_vez.text = "EMPATE!"

	batalha_finalizada.emit(resultado_final)

	funcao_futura_fim_da_batalha(resultado_final)


# ==================================================
# FIM DA BATALHA
# ==================================================

func funcao_futura_fim_da_batalha(vencedor: String) -> void:

	Gobla.PODEJOGAR = true

	get_tree().change_scene_to_file(
		"res://Scenas/main.tscn"
	)
