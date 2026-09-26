extends Node3D

@export var carta = {
	"nome": "Emilia",
	"vida": 100,
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
}
@export var animation_player: AnimationPlayer 
@export var hp_maximo := 100

var hp := 100


func _ready() -> void:

	hp = hp_maximo


func receber_dano(dano: int) -> void:

	hp -= dano

	hp = max(hp, 0)

	print(
		name,
		" recebeu ",
		dano,
		" de dano."
	)

	print(
		"HP: ",
		hp,
		"/",
		hp_maximo
	)

	if hp <= 0:
		morrer()


func morrer() -> void:

	print(name, " morreu!")

	# Aqui depois podemos colocar
	# animação de morte.
