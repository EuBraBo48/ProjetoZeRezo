extends Node3D

var qualCart: String = ""

@export var cart_1: Node2D 
@export var cart_2: Node2D 
@export var cart_3: Node2D 

@export var ps: Marker3D 
@export var psN: Marker3D 
var BRUXA = preload("res://Scenas/modelos/perns/bruxa.tscn")
var ESZA = preload("res://Scenas/modelos/perns/esza.tscn")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Gobla.InimeDaCena == BRUXA or Gobla.InimeDaCena == ESZA:
		print("etrete")
		var inimigN = Gobla.InimeDaCena.instantiate()
		psN.add_child(inimigN)
		cart_1.sprite.texture = load(Gobla.cart1["normal"])
		cart_2.sprite.texture = load(Gobla.cart2["normal"])
		cart_3.sprite.texture = load(Gobla.cart3["normal"])

	else:
		var inimig = Gobla.InimeDaCena.instantiate()
		ps.add_child(inimig)
		cart_1.sprite.texture = load(Gobla.cart1["normal"])
		cart_2.sprite.texture = load(Gobla.cart2["normal"])
		cart_3.sprite.texture = load(Gobla.cart3["normal"])


func SelencPersong() -> void:
	pass
