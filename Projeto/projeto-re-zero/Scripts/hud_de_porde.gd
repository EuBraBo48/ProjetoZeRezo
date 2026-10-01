extends Control


# ==================================================
# REFERÊNCIAS
# ==================================================

@export var habilidadeDoPlayer: Node3D

@export var battle_manager: Node3D

@export var barra_vida: ProgressBar


# ==================================================
# NOME DA CARTA / PERSONAGEM
# ==================================================

@export var label_nome_carta: Label


# ==================================================
# LABELS DAS HABILIDADES
# ==================================================

@export var label_habilidade_1: Label

@export var label_habilidade_2: Label

@export var label_habilidade_3: Label


# ==================================================
# CONTROLE
# ==================================================

var pode_jogar := false


# ==================================================
# READY
# ==================================================

func _ready() -> void:

	bloquear_jogador()


# ==================================================
# LIBERAR PLAYER
# ==================================================

func liberar_jogador() -> void:

	pode_jogar = true

	print("PLAYER PODE JOGAR")

	show()

	atualizar_barra_vida()

	atualizar_habilidades()


# ==================================================
# BLOQUEAR PLAYER
# ==================================================

func bloquear_jogador() -> void:

	pode_jogar = false

	print("PLAYER NÃO PODE JOGAR")


# ==================================================
# ATUALIZAR VIDA
# ==================================================

func atualizar_barra_vida() -> void:

	if habilidadeDoPlayer == null:
		return

	if barra_vida == null:
		return

	if habilidadeDoPlayer.carta.is_empty():
		return

	barra_vida.max_value = (
		habilidadeDoPlayer.carta["vida_maxima"]
	)

	barra_vida.value = (
		habilidadeDoPlayer.carta["vida"]
	)


# ==================================================
# ATUALIZAR HABILIDADES
# ==================================================

func atualizar_habilidades() -> void:

	if habilidadeDoPlayer == null:
		return

	if habilidadeDoPlayer.carta.is_empty():
		return


	# ==================================================
	# NOME DO PERSONAGEM
	# ==================================================

	if label_nome_carta != null:

		label_nome_carta.text = (
			habilidadeDoPlayer.carta["nome"]
		)


	# ==================================================
	# PEGA AS HABILIDADES
	# ==================================================

	var habilidades = (
		habilidadeDoPlayer.carta["habilidades"]
	)


	# ==================================================
	# HABILIDADE 1
	# ==================================================

	if label_habilidade_1 != null:

		if habilidades.size() > 0:

			label_habilidade_1.text = (
				habilidades[0]["nome"]
			)


	# ==================================================
	# HABILIDADE 2
	# ==================================================

	if label_habilidade_2 != null:

		if habilidades.size() > 1:

			label_habilidade_2.text = (
				habilidades[1]["nome"]
			)


	# ==================================================
	# HABILIDADE 3
	# ==================================================

	if label_habilidade_3 != null:

		if habilidades.size() > 2:

			label_habilidade_3.text = (
				habilidades[2]["nome"]
			)


# ==================================================
# BOTÃO PRINCIPAL
# ==================================================

func _on_button_pressed() -> void:

	if visible:

		hide()

	else:

		show()


# ==================================================
# HABILIDADE 1
# ==================================================

func _on_bh_1_pressed() -> void:

	if not pode_jogar:
		return

	usar_habilidade(0)


# ==================================================
# HABILIDADE 2
# ==================================================

func _on_bh_2_pressed() -> void:

	if not pode_jogar:
		return

	usar_habilidade(1)


# ==================================================
# HABILIDADE 3
# ==================================================

func _on_bh_3_pressed() -> void:

	if not pode_jogar:
		return

	usar_habilidade(2)


# ==================================================
# ESCOLHER HABILIDADE
# ==================================================

func usar_habilidade(index: int) -> void:

	if not pode_jogar:
		return

	if habilidadeDoPlayer == null:
		return

	if battle_manager == null:
		return

	if habilidadeDoPlayer.carta.is_empty():
		return


	# ==================================================
	# PEGA AS HABILIDADES DA CARTA ATUAL
	# ==================================================

	var habilidades = (
		habilidadeDoPlayer.carta["habilidades"]
	)


	# ==================================================
	# VERIFICA SE EXISTE ESSA HABILIDADE
	# ==================================================

	if index < 0 or index >= habilidades.size():
		return


	# ==================================================
	# PEGA A HABILIDADE
	# ==================================================

	var habilidade = habilidades[index]


	# ==================================================
	# DEBUG
	# ==================================================

	print("========================")
	print("HABILIDADE ESCOLHIDA")

	print(
		"PERSONAGEM: ",
		habilidadeDoPlayer.carta["nome"]
	)

	print(
		"NOME: ",
		habilidade["nome"]
	)

	print(
		"DANO: ",
		habilidade["dano"]
	)

	print("========================")


	# ==================================================
	# IMPEDE CLICAR NOVAMENTE
	# ==================================================

	bloquear_jogador()


	# ==================================================
	# MANDA PARA O BATTLE MANAGER
	# ==================================================

	await battle_manager.jogador_usou_habilidade(
		habilidade
	)
