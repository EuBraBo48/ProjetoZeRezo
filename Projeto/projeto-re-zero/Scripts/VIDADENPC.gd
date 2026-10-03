extends Node3D

# ==================================================
# HUD
# ==================================================
@export var hud_de_porde: Control

# ==================================================
# CARTAS DOS PERSONAGENS (sempre chave minúscula)
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
	"garfiel": {
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
signal vida_mudou(vida_atual: int, vida_maxima: int)

# ==================================================
# READY
# ==================================================
func _ready() -> void:
	# ==================================================
	# PERSONAGEM ESCOLHIDO (força minúsculo)
	# ==================================================
	var nome_personagem: String = str(Gobla.personagem_player).to_lower()

	# ==================================================
	# PEGA A CARTA
	# ==================================================
	if nome_personagem != "" and cartas.has(nome_personagem):
		carta = cartas[nome_personagem].duplicate(true)
	else:
		print("AVISO: Personagem não encontrado → usando Emilia")
		carta = cartas["emilia"].duplicate(true)
		nome_personagem = "emilia"

	# ==================================================
	# APLICA UPGRADES (VIDA + DANO)
	# ==================================================
	aplicar_upgrades()

	# ==================================================
	# SALVA A CARTA ATUAL
	# ==================================================
	Gobla.carta_player = carta

	# ==================================================
	# DEBUG DOS UPGRADES
	# ==================================================
	print("========================")
	print("PLAYER CRIADO")
	print("Personagem: ", carta["nome"])
	print("------------------------")
	print("POWER HP  → Nível: ", get_nivel("vida"), " | Bônus: +", bonus_por_nivel(get_nivel("vida")))
	print("Vida final: ", carta["vida"], "/", carta["vida_maxima"])
	print("------------------------")
	print("POWER DMG → Nível: ", get_nivel("Dano"), " | Bônus: +", bonus_por_nivel(get_nivel("Dano")))
	for habilidade in carta["habilidades"]:
		print(habilidade["nome"], ": ", habilidade["dano"])
	print("========================")

	# ==================================================
	# ANIMATION PLAYER
	# ==================================================
	animation_player = find_child("AnimationPlayer", true, false)
	if animation_player:
		print("AnimationPlayer do Player encontrado!")
	else:
		print("AnimationPlayer do Player NÃO encontrado!")

	# ==================================================
	# COMEÇA PARADO
	# ==================================================
	tocar_idle()

	# ==================================================
	# ATUALIZA VIDA
	# ==================================================
	vida_mudou.emit(carta["vida"], carta["vida_maxima"])

# ==================================================
# APLICAR TODOS OS UPGRADES
# ==================================================
func aplicar_upgrades() -> void:
	# ---- VIDA ----
	var nivel_vida: int = get_nivel("vida")
	var bonus_vida: int = bonus_por_nivel(nivel_vida)

	carta["vida_maxima"] += bonus_vida
	carta["vida"] = carta["vida_maxima"]

	# ---- DANO ----
	var nivel_dano: int = get_nivel("Dano")
	var bonus_dano: int = bonus_por_nivel(nivel_dano)

	for habilidade in carta["habilidades"]:
		if habilidade["dano"] > 0:
			habilidade["dano"] += bonus_dano

# ==================================================
# PEGAR NÍVEL (VIDA ou DANO)
# ==================================================
func get_nivel(tipo: String) -> int:
	var nome: String = str(Gobla.personagem_player).to_lower()

	# Carta 1
	if Gobla.cart1 != null and Gobla.cart1.has("nome"):
		if str(Gobla.cart1["nome"]).to_lower() == nome:
			var valor = Gobla.get(tipo + "DaCart1")
			return valor if valor != null else 0

	# Carta 2
	if Gobla.cart2 != null and Gobla.cart2.has("nome"):
		if str(Gobla.cart2["nome"]).to_lower() == nome:
			var valor = Gobla.get(tipo + "DaCart2")
			return valor if valor != null else 0

	# Carta 3
	if Gobla.cart3 != null and Gobla.cart3.has("nome"):
		if str(Gobla.cart3["nome"]).to_lower() == nome:
			var valor = Gobla.get(tipo + "DaCart3")
			return valor if valor != null else 0

	print("Nível não encontrado para: ", nome, " | tipo: ", tipo)
	return 0

# ==================================================
# BÔNUS POR NÍVEL (aqui você controla o poder)
# ==================================================
func bonus_por_nivel(nivel: int) -> int:
	match nivel:
		1:
			return 0
		2:
			return 22
		3:
			return 35
		_:
			return 35 + (nivel - 3) * 10

# ==================================================
# IDLE / PARADO
# ==================================================
func tocar_idle() -> void:
	if animation_player == null:
		return
	animation_player.stop()
	if animation_player.has_animation("mixamo_com"):
		animation_player.play("mixamo_com")

# ==================================================
# ATAQUE
# ==================================================
func atacar_animacao() -> void:
	if animation_player == null:
		print("Player não possui AnimationPlayer!")
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
	Gobla.carta_player = carta
	vida_mudou.emit(carta["vida"], carta["vida_maxima"])

	print("========================")
	print("PLAYER RECEBEU DANO")
	print("Personagem: ", carta["nome"])
	print("Dano: ", dano)
	print("Vida: ", carta["vida"], "/", carta["vida_maxima"])
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
	carta["vida"] = carta["vida_maxima"]
	Gobla.carta_player = carta
	vida_mudou.emit(carta["vida"], carta["vida_maxima"])
