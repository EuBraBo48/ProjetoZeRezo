extends Node3D

# ==================================================
# PERSONAGENS / CARTAS DA IA (pouca vida + dano alto)
# ==================================================

var personagens: Dictionary = {
	"bete": {
		"cena": preload("res://Scenas/modelos/perns/NpcRuin/bete_aniRuin.tscn"),
		"carta": {
			"nome": "Bete",
			"vida": 100,
			"vida_maxima": 100,
			"habilidades": [
				{"nome": "Magia", "dano": 30},
				{"nome": "Explosão", "dano": 40},
				{"nome": "Especial", "dano": 48}
			]
		}
	},
	"emilia": {
		"cena": preload("res://Scenas/modelos/perns/NpcRuin/emiliaaniRuin.tscn"),
		"carta": {
			"nome": "Emilia",
			"vida": 135,
			"vida_maxima": 105,
			"habilidades": [
				{"nome": "Gelo", "dano": 30},
				{"nome": "Barreira", "dano": 40},
				{"nome": "Magia de Gelo", "dano": 38}
			]
		}
	},
	"grafil": {
		"cena": preload("res://Scenas/modelos/perns/NpcRuin/grafilRuin.tscn"),
		"carta": {
			"nome": "Garfiel",
			"vida": 135,
			"vida_maxima": 135,
			"habilidades": [
				{"nome": "Soco", "dano": 40},
				{"nome": "Soco Forte", "dano": 32},
				{"nome": "Especial", "dano": 48}
			]
		}
	},
	"ham": {
		"cena": preload("res://Scenas/modelos/perns/NpcRuin/ham_a_niRuin.tscn"),
		"carta": {
			"nome": "Ham",
			"vida": 145,
			"vida_maxima": 145,
			"habilidades": [
				{"nome": "Mordida", "dano": 33},
				{"nome": "Investida", "dano": 46},
				{"nome": "Especial", "dano": 52}
			]
		}
	},
	"hem": {
		"cena": preload("res://Scenas/modelos/perns/NpcRuin/hem_anRuin.tscn"),
		"carta": {
			"nome": "Hem",
			"vida": 115,
			"vida_maxima": 115,
			"habilidades": [
				{"nome": "Ataque", "dano": 36},
				{"nome": "Ataque Forte", "dano": 30},
				{"nome": "Especial", "dano": 42}
			]
		}
	},
	"prisila": {
		"cena": preload("res://Scenas/modelos/perns/NpcRuin/prisilaRuin.tscn"),
		"carta": {
			"nome": "Prisila",
			"vida": 125,
			"vida_maxima": 125,
			"habilidades": [
				{"nome": "Corte", "dano": 30},
				{"nome": "Ataque Poderoso", "dano": 40},
				{"nome": "Especial", "dano": 46}
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
	label_dano_inimigo.add_theme_font_size_override("font_size", 40)
	label_dano_inimigo.add_theme_color_override("font_color", Color.WHITE)
	label_dano_inimigo.add_theme_color_override("font_shadow_color", Color.BLACK)
	label_dano_inimigo.add_theme_constant_override("shadow_offset_x", 3)
	label_dano_inimigo.add_theme_constant_override("shadow_offset_y", 3)
	get_tree().root.add_child(label_dano_inimigo)

# ==================================================
# CRIAR PERSONAGEM
# ==================================================
func criar_novo_personagem() -> void:
	if personagens_usados.size() >= personagens.size():
		personagens_usados.clear()

	var disponiveis: Array = []
	for nome_personagem in personagens.keys():
		if not personagens_usados.has(nome_personagem):
			disponiveis.append(nome_personagem)

	var nome_escolhido: String = disponiveis.pick_random()
	personagens_usados.append(nome_escolhido)

	var dados = personagens[nome_escolhido]

	# ==================================================
	# PEGA A CARTA
	# ==================================================
	carta = dados["carta"].duplicate(true)
	carta["vida"] = carta["vida_maxima"]

	# ==================================================
	# INSTANTIA PERSONAGEM
	# ==================================================
	personagem = dados["cena"].instantiate()
	add_child(personagem)

	# ==================================================
	# ANIMATION PLAYER
	# ==================================================
	animation_player = personagem.find_child("AnimationPlayer", true, false)
	if animation_player:
		print("AnimationPlayer do inimigo encontrado!")
	else:
		print("AnimationPlayer do inimigo NÃO encontrado!")

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
	if animation_player.has_animation("mixamo_com"):
		animation_player.play("mixamo_com")

# ==================================================
# IA INTELIGENTE (escolhe habilidade)
# ==================================================
func jogar() -> Dictionary:
	print("IA está pensando...")
	await get_tree().create_timer(1.0).timeout

	var habilidades = carta["habilidades"]

	# Ordena do mais fraco pro mais forte
	habilidades.sort_custom(func(a, b): return a["dano"] < b["dano"])

	var fraca = habilidades[0]
	var media = habilidades[1]
	var forte = habilidades[2]

	# Tenta pegar a vida atual do player
	var vida_player = 999
	var battle_manager = get_tree().get_first_node_in_group("battle_manager")
	if battle_manager and is_instance_valid(battle_manager.carta_player):
		if battle_manager.carta_player.carta.has("vida"):
			vida_player = battle_manager.carta_player.carta["vida"]

	var escolha: Dictionary

	# ========== LÓGICA DA IA ==========
	if vida_player <= forte["dano"]:
		# Dá pra matar → usa o mais forte
		escolha = forte
		print("IA: Posso matar! Usando golpe forte")
	elif vida_player <= media["dano"] + 15:
		# Quase matando → usa médio ou forte
		escolha = [media, forte].pick_random()
		print("IA: Quase matando, golpe médio/forte")
	else:
		# Player ainda tem bastante vida
		# 60% forte, 30% médio, 10% fraco
		var sorte = randi() % 100
		if sorte < 60:
			escolha = forte
		elif sorte < 90:
			escolha = media
		else:
			escolha = fraca
		print("IA: Player vivo, escolhendo com peso")

	print("IA escolheu: ", escolha["nome"], " (", escolha["dano"], ")")
	return escolha

# ==================================================
# ATAQUE
# ==================================================
func atacar() -> void:
	if animation_player == null:
		print("IA não possui AnimationPlayer!")
		return

	animation_player.stop()
	if animation_player.has_animation("mixamo_com_001"):
		animation_player.play("mixamo_com_001")
		await get_tree().create_timer(2.4).timeout

	tocar_idle()

# ==================================================
# RECEBER DANO
# ==================================================
func receber_dano(dano: int) -> void:
	carta["vida"] -= dano
	carta["vida"] = max(carta["vida"], 0)

	print("========================")
	print("IA RECEBEU DANO")
	print("Personagem: ", carta["nome"])
	print("Dano: ", dano)
	print("Vida: ", carta["vida"], "/", carta["vida_maxima"])
	print("========================")

	mostrar_dano_inimigo(dano)

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

	var battle_manager = get_tree().get_first_node_in_group("battle_manager")
	if battle_manager == null:
		print("ERRO: BattleManager não encontrado!")
		return

	var player = battle_manager.carta_player
	if not is_instance_valid(player):
		print("ERRO: Player não existe!")
		return

	var camera = get_viewport().get_camera_3d()
	if camera == null:
		print("ERRO: Câmera 3D não encontrada!")
		return

	var pos_3d = player.global_position
	pos_3d.y += 2.0
	var pos_tela = camera.unproject_position(pos_3d)
	label_dano_inimigo.position = pos_tela

	print("DANO DA IA APARECENDO NO PLAYER: -", dano)

	var pos_inicial = label_dano_inimigo.position
	var pos_final = pos_inicial + Vector2(0, -60)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(label_dano_inimigo, "position", pos_final, 1.0)
	tween.tween_property(label_dano_inimigo, "modulate:a", 0.0, 1.0)

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
	print("TROCANDO PERSONAGEM DO INIMIGO")

	if is_instance_valid(label_dano_inimigo):
		label_dano_inimigo.queue_free()
		label_dano_inimigo = null

	if is_instance_valid(personagem):
		personagem.queue_free()

	personagem = null
	animation_player = null

	criar_novo_personagem()
