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
var PontoDePar := 0
var vidaDaCart1 :int = 1
var DanoDaCart1 :int = 1
var vidaDaCart2 :int = 1
var DanoDaCart2 :int = 1
var vidaDaCart3 :int = 1
var DanoDaCart3 :int = 1

var InimeDaCena = preload("res://Scenas/modelos/perns/bruxa.tscn")

var posicaoPlay: Vector3 = Vector3(-1.209,18.011,-4.052)
