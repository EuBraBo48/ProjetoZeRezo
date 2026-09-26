extends Node2D

var draggable := false
var is_dragging := false
var is_inside_dropable := false

var body_ref: StaticBody2D = null
var offset := Vector2.ZERO
var initial_pos := Vector2.ZERO

@export var sprite: Sprite2D
@export var per: Marker3D

const BETE_ANI = preload("res://Scenas/modelos/perns/Npc/bete_ani.tscn")
const EMILIAANI = preload("res://Scenas/modelos/perns/Npc/emiliaani.tscn")
const GRAFIL = preload("res://Scenas/modelos/perns/Npc/grafil.tscn")
const HAM_A_NI = preload("res://Scenas/modelos/perns/Npc/ham_a_ni.tscn")
const HEM_AN = preload("res://Scenas/modelos/perns/Npc/hem_an.tscn")
const PRISILA = preload("res://Scenas/modelos/perns/Npc/prisila.tscn")






func _ready() -> void:
	initial_pos = global_position


func _process(_delta: float) -> void:
	if Gobla.PODEJOGAR:
		if draggable and Input.is_action_just_pressed("click"):
			if Gobla.carta_sendo_arrastada != null:
				return
			Gobla.carta_sendo_arrastada = self
			is_dragging = true
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position

		if is_dragging and Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset

		if is_dragging and Input.is_action_just_released("click"):
			is_dragging = false
			Gobla.carta_sendo_arrastada = null
			var tween := get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_QUAD)
			# Está dentro do lugar correto
			if is_inside_dropable and body_ref != null:
				tween.tween_property(self,"global_position",body_ref.global_position,0.2)
				Gobla.PODEJOGAR = false
				COLOCARPer()

		# Está fora
			else:
				tween.tween_property(
				self,
				"global_position",
				initial_pos,
				0.2
			)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body
		body.modulate = Color(Color.REBECCA_PURPLE, 1.0)



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body_ref = null
		body.modulate = Color(Color.REBECCA_PURPLE, 0.7)



func _on_area_2d_mouse_entered() -> void:
	if Gobla.carta_sendo_arrastada == null:
		draggable = true
		scale = Vector2(1.05, 1.05)



func _on_area_2d_mouse_exited() -> void:
	if not is_dragging:
		draggable = false
		scale = Vector2(1,1)


func COLOCARPer() -> void:
	if sprite.texture == load("res://icon.svg"):
		var PerLo = BETE_ANI.instantiate()
		per.add_child(PerLo)
