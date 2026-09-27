extends Node

var PODEJOGAR = true
# Personagem escolhido pelo PLAYER
var personagem_player: String = ""
# Dados do personagem escolhido
var carta_player: Dictionary = {}
var cart1
var cart2
var cart3
var carta_sendo_arrastada: Node2D = null

var Vitoria := 0.0
var Mortes := 0.0
var vidaDaCart :int = 0
var DanoDaCart :int = 0

var InimeDaCena = preload("res://Scenas/modelos/perns/bruxa.tscn")

var posicaoPlay: Vector3 = Vector3(0,0,0)
