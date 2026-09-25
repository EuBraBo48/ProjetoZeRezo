extends Node3D

var qualCart: String = ""

@export var cart_1: TextureButton 
@export var cart_2: TextureButton 
@export var cart_3: TextureButton 
@onready var ps: Marker3D = $personagem/Marker3D

func _ready() -> void:
	var inimig = Gobla.InimeDaCena.instantiate()
	ps.add_child(inimig)
	cart_1.texture_normal = load(Gobla.cart1["normal"])
	cart_1.texture_hover = load(Gobla.cart1["hover"])
	cart_2.texture_normal = load(Gobla.cart2["normal"])
	cart_2.texture_hover = load(Gobla.cart2["hover"])
	cart_3.texture_normal = load(Gobla.cart3["normal"])
	cart_3.texture_hover = load(Gobla.cart3["hover"])


func SelencPersong() -> void:
	pass
