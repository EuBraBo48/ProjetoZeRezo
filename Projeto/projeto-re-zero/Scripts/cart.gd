extends Control

var personagens = {
	"emilia": {
		"normal": "res://assents/cartes/cartsEmil.png",
		"habilidades": [
			"Prisão de Gelo",
			"Lança de Gelo",
			"Tempestade de Gelo"
		]
	},

	"bete": {
		"normal": "res://assents/cartes/cartaBet.png",
		"habilidades": [
			"Al Shamac",
			"Al Huma",
			"Al Minya"
		]
	},

	"ham": {
		"normal": "res://assents/cartes/cartRem.png",
		"habilidades": [
			"Rajada de Vento",
			"Al Wind",
			"Força de Oni"
		]
	},

	"hem": {
		"normal": "res://assents/cartes/cartRam.png",
		"habilidades": [
			"Mordida",
			"Investida",
			"Ataque Selvagem"
		]
	},

	"garfiel": {
		"normal": "res://assents/cartes/cartGufiel.png",
		"habilidades": [
			"Soco de Ferro",
			"Golpe Bestial",
			"Transformação Tigre"
		]
	},

	"prisila": {
		"normal": "res://assents/cartes/CartaPRisl.png",
		"habilidades": [
			"Corte de Espada",
			"Yang Magic",
			"Sol Carmesim"
		]
	}
}

@export var cart_1: Sprite2D 
@export var cart_2: Sprite2D 
@export var cart_3: Sprite2D 

func _ready() -> void:
	Sorteio()

func Sorteio() -> void:

	# Cria uma lista com todos os personagens
	var disponiveis = personagens.keys().duplicate()
	var car1 = disponiveis.pick_random()
	disponiveis.erase(car1)
	cart_1.texture = load(personagens[car1]["normal"])

	Gobla.cart1 = {"nome": car1,"normal": personagens[car1]["normal"],"habilidades": personagens[car1]["habilidades"]}

	var car2 = disponiveis.pick_random()
	disponiveis.erase(car2)
	cart_2.texture = load(personagens[car2]["normal"])
	Gobla.cart2 = {"nome": car2,"normal": personagens[car2]["normal"],"habilidades": personagens[car2]["habilidades"]}

	var car3 = disponiveis.pick_random()
	disponiveis.erase(car3)
	cart_3.texture = load(personagens[car3]["normal"])
	Gobla.cart3 = {"nome": car3,"normal": personagens[car3]["normal"],"habilidades": personagens[car3]["habilidades"]}
	get_tree().change_scene_to_file("res://Scenas/main.tscn")
