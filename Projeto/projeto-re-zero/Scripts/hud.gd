extends Control

@export var progress_bar: ProgressBar 
@export var texture_progress_bar: TextureProgressBar 
@export var Pontos: Label  

var vidaMaz:= 5.0
var Venceu:= 0

var viMoMAx:= 100.0
var vidaMor:= 0.0
@export var par_visual: Control



func _ready() -> void:
	$"../../AudioStreamPlayer2".play()
	Venceu = Gobla.Vitoria
	progress_bar.max_value = vidaMaz
	vidaMor = Gobla.Mortes
	texture_progress_bar.max_value = viMoMAx


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("AbriCartds"):
		if par_visual.visible:
			par_visual.hide()
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			par_visual.show()
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Gobla.Mortes >= 100 and Input.is_action_just_pressed("pode"):
		Gobla.Mortes = 0
		Gobla.Vitoria = 0.0
		Gobla.vidaDaCart1 = 1
		Gobla.DanoDaCart1 = 1
		Gobla.vidaDaCart2 = 1
		Gobla.DanoDaCart2 = 1
		Gobla.vidaDaCart3 = 1
		Gobla.DanoDaCart3 = 1
		Gobla.posicaoPlay = Vector3(-1.209,0.667,-7.611)
		get_tree().change_scene_to_file("res://Scenas/modelos/cart.tscn")
	Pontos.text = "Seus Pontos: "+ str(Gobla.PontoDePar)
	progress_bar.value = lerp(progress_bar.value, Gobla.Vitoria,delta * 5.0)
	texture_progress_bar.value = lerp(texture_progress_bar.value, Gobla.Mortes,delta * 5)
