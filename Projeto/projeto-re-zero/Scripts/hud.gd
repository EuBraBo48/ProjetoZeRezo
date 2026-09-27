extends Control

@export var progress_bar: ProgressBar 
@export var texture_progress_bar: TextureProgressBar 

var vidaMaz:= 5.0
var Venceu:= 0

var viMoMAx:= 100.0
var vidaMor:= 0.0



func _ready() -> void:
	Venceu = Gobla.Vitoria
	progress_bar.max_value = vidaMaz
	vidaMor = Gobla.Mortes
	texture_progress_bar.max_value = viMoMAx


func _process(delta: float) -> void:
	progress_bar.value = lerp(progress_bar.value, Gobla.Vitoria,delta * 5.0)
	texture_progress_bar.value = lerp(texture_progress_bar.value, Gobla.Mortes,delta * 5)
