extends Control

var personagens = {
	"emilia": {
		"normal": "res://icon.svg",
		"hover": "res://icon.svg"
	},

	"bete": {
		"normal": "res://icon.svg",
		"hover": "res://icon.svg"
	},

	"ham": {
		"normal": "res://icon.svg",
		"hover": "res://icon.svg"
	},

	"hem": {
		"normal": "res://icon.svg",
		"hover": "res://icon.svg"
	},

	"garfiel": {
		"normal": "res://icon.svg",
		"hover": "res://icon.svg"
	},

	"prisila": {
		"normal": "res://icon.svg",
		"hover": "res://icon.svg"
	}
}
@export var cart_1: TextureButton 
@export var cart_2: TextureButton 
@export var cart_3: TextureButton 

func _ready() -> void:
	Sorteio()
	


func Sorteio() -> void:
	var nomes1 = personagens.keys()
	var car1 = nomes1.pick_random()
	cart_1.texture_normal = load(personagens[car1]["normal"])
	cart_1.texture_hover = load(personagens[car1]["hover"])
	Gobla.cart1 = personagens[car1]
	var nomes2 = personagens.keys()
	var car2 = nomes2.pick_random()
	cart_2.texture_normal = load(personagens[car2]["normal"])
	cart_2.texture_hover = load(personagens[car2]["hover"])
	Gobla.cart2 = personagens[car2]
	var nomes3 = personagens.keys()
	var car3 = nomes3.pick_random()
	cart_3.texture_normal = load(personagens[car3]["normal"])
	cart_3.texture_hover = load(personagens[car3]["hover"])
	Gobla.cart3 = personagens[car3]
	get_tree().change_scene_to_file("res://Scenas/batalha.tscn")
	
	
