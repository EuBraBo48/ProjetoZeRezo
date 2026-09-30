extends Control

var personagens = {
	"emilia": {
		"normal": "res://assents/cartes/cartsEmil.png"
	},

	"bete": {
		"normal": "res://assents/cartes/cartaBet.png"
	},

	"ham": {
		"normal": "res://assents/cartes/cartRem.png"
	},

	"hem": {
		"normal": "res://assents/cartes/cartRam.png"
	},

	"garfiel": {
		"normal": "res://assents/cartes/cartGufiel.png"
	},

	"prisila": {
		"normal": "res://assents/cartes/CartaPRisl.png"
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

	Gobla.cart1 = {"nome": car1,"normal": personagens[car1]["normal"]}

	var car2 = disponiveis.pick_random()
	disponiveis.erase(car2)
	cart_2.texture = load(personagens[car2]["normal"])
	Gobla.cart2 = {"nome": car2,"normal": personagens[car2]["normal"]}

	var car3 = disponiveis.pick_random()
	disponiveis.erase(car3)
	cart_3.texture = load(personagens[car3]["normal"])
	Gobla.cart3 = {"nome": car3,"normal": personagens[car3]["normal"]}
	get_tree().change_scene_to_file("res://Scenas/main.tscn")
