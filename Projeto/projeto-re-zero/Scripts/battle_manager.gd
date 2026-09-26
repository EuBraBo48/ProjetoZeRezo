extends Node3D

enum Turno {
	PLAYER,
	IA,
	FIM
}

var turno_atual: Turno = Turno.PLAYER


@export var enemy_ai: Node
@export var player_battle: Node

var batalha_terminou := false


func _ready() -> void:
	pass
	#iniciar_batalha()


func iniciar_batalha() -> void:
	batalha_terminou = false
	iniciar_turno_player()


func iniciar_turno_player() -> void:
	if batalha_terminou:
		return

	turno_atual = Turno.PLAYER

	print("===== TURNO DO PLAYER =====")

	if player_battle:
		player_battle.liberar_jogador()


func finalizar_turno_player(habilidade) -> void:
	if turno_atual != Turno.PLAYER:
		return

	print("Player escolheu: ", habilidade["nome"])

	await executar_ataque(
		player_battle,
		enemy_ai,
		habilidade
	)

	if verificar_morte():
		return

	iniciar_turno_ia()


func iniciar_turno_ia() -> void:
	if batalha_terminou:
		return

	turno_atual = Turno.IA

	print("===== TURNO DA IA =====")

	await get_tree().create_timer(0.5).timeout

	if enemy_ai:
		enemy_ai.jogar()


func finalizar_turno_ia(habilidade) -> void:
	if turno_atual != Turno.IA:
		return

	print("IA escolheu: ", habilidade["nome"])

	await executar_ataque(
		enemy_ai,
		player_battle,
		habilidade
	)

	if verificar_morte():
		return

	await get_tree().create_timer(0.5).timeout

	iniciar_turno_player()


func executar_ataque(atacante, alvo, habilidade) -> void:

	print(
		atacante.name,
		" usou ",
		habilidade["nome"]
	)

	# Aqui você vai tocar a animação
	# Exemplo:
	#
	# atacante.play("attack")
	# await atacante.animation_finished

	await get_tree().create_timer(0.5).timeout

	var dano = habilidade["dano"]

	if alvo.has_method("receber_dano"):
		alvo.receber_dano(dano)

	print("Dano causado: ", dano)

	await get_tree().create_timer(0.5).timeout


func verificar_morte() -> bool:

	if player_battle.hp <= 0:
		player_morreu()
		return true

	if enemy_ai.hp <= 0:
		enemy_morreu()
		return true

	return false


func player_morreu() -> void:

	batalha_terminou = true
	turno_atual = Turno.FIM

	print("PLAYER MORREU!")


func enemy_morreu() -> void:

	batalha_terminou = true
	turno_atual = Turno.FIM

	print("INIMIGO MORREU!")
