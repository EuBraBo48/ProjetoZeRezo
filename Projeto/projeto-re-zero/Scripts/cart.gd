extends Control

var personagens = {
	"emilia": {
		"normal": "res://icon.svg"
	},

	"bete": {
		"normal": "res://icon.svg"
	},

	"ham": {
		"normal": "res://icon.svg"
	},

	"hem": {
		"normal": "res://icon.svg"
	},

	"garfiel": {
		"normal": "res://icon.svg"
	},

	"prisila": {
		"normal": "res://icon.svg"
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
	get_tree().change_scene_to_file("res://Scenas/batalha.tscn")
