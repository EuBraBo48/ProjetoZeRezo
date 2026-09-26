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
	var nomes1 = personagens.keys()
	var car1 = nomes1.pick_random()
	cart_1.texture = load(personagens[car1]["normal"])
	Gobla.cart1 = personagens[car1]
	var nomes2 = personagens.keys()
	var car2 = nomes2.pick_random()
	cart_2.texture = load(personagens[car2]["normal"])
	Gobla.cart2 = personagens[car2]
	var nomes3 = personagens.keys()
	var car3 = nomes3.pick_random()
	cart_3.texture = load(personagens[car3]["normal"])
	Gobla.cart3 = personagens[car3]
	get_tree().change_scene_to_file("res://Scenas/batalha.tscn")
