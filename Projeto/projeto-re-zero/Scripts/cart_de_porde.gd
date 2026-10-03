extends Sprite2D

@export var color_rect: Sprite2D
@export var sprite_2d_3: Sprite2D
@export var spr2: Sprite2D
@export var spr3: Sprite2D
@export var spr1: Sprite2D
@export var qualCart: int
@export var nome: Label
@export var UpVi: Label
@export var UpPo: Label
@export var up_po: Button
@export var up_vi: Button
@export var h_1: Label 
@export var h_2: Label 
@export var h_3: Label



func _ready() -> void:
	if qualCart == 1:
		h_1.text = Gobla.cart1["habilidades"][0]
		h_2.text = Gobla.cart1["habilidades"][1]
		h_3.text = Gobla.cart1["habilidades"][2]
		sprite_2d_3.texture = load(Gobla.cart1["normal"])
	elif qualCart == 2:
		h_1.text = Gobla.cart2["habilidades"][0]
		h_2.text = Gobla.cart2["habilidades"][1]
		h_3.text = Gobla.cart2["habilidades"][2]
		sprite_2d_3.texture = load(Gobla.cart2["normal"])
	elif qualCart == 3:
		h_1.text = Gobla.cart3["habilidades"][0]
		h_2.text = Gobla.cart3["habilidades"][1]
		h_3.text = Gobla.cart3["habilidades"][2]
		sprite_2d_3.texture = load(Gobla.cart3["normal"])


func _process(_delta: float) -> void:

	if qualCart == 1:

		nome.text = "nome: " + Gobla.cart1["nome"]

		UpPo.text = "PowerDMG: nivel " + str(Gobla.DanoDaCart1)
		UpVi.text = "PowerHP: nivel " + str(Gobla.vidaDaCart1)

		if Gobla.vidaDaCart1 >= 3:
			up_vi.text = "MAX"
			up_vi.disabled = true
		elif Gobla.vidaDaCart1 == 2:
			up_vi.text = "40"
			up_vi.disabled = false
		else:
			up_vi.text = "20"
			up_vi.disabled = false

		if Gobla.DanoDaCart1 >= 3:
			up_po.text = "MAX"
			up_po.disabled = true
		elif Gobla.DanoDaCart1 == 2:
			up_po.text = "40"
			up_po.disabled = false
		else:
			up_po.text = "20"
			up_po.disabled = false


	elif qualCart == 2:

		nome.text = "nome: " + Gobla.cart2["nome"]

		UpPo.text = "PowerDMG: nivel " + str(Gobla.DanoDaCart2)
		UpVi.text = "PowerHP: nivel " + str(Gobla.vidaDaCart2)

		if Gobla.vidaDaCart2 >= 3:
			up_vi.text = "MAX"
			up_vi.disabled = true
		elif Gobla.vidaDaCart2 == 2:
			up_vi.text = "40"
			up_vi.disabled = false
		else:
			up_vi.text = "20"
			up_vi.disabled = false

		if Gobla.DanoDaCart2 >= 3:
			up_po.text = "MAX"
			up_po.disabled = true
		elif Gobla.DanoDaCart2 == 2:
			up_po.text = "40"
			up_po.disabled = false
		else:
			up_po.text = "20"
			up_po.disabled = false


	elif qualCart == 3:

		nome.text = "nome: " + Gobla.cart3["nome"]

		UpPo.text = "PowerDMG: nivel " + str(Gobla.DanoDaCart3)
		UpVi.text = "PowerHP: nivel " + str(Gobla.vidaDaCart3)

		if Gobla.vidaDaCart3 >= 3:
			up_vi.text = "MAX"
			up_vi.disabled = true
		elif Gobla.vidaDaCart3 == 2:
			up_vi.text = "40"
			up_vi.disabled = false
		else:
			up_vi.text = "20"
			up_vi.disabled = false

		if Gobla.DanoDaCart3 >= 3:
			up_po.text = "MAX"
			up_po.disabled = true
		elif Gobla.DanoDaCart3 == 2:
			up_po.text = "40"
			up_po.disabled = false
		else:
			up_po.text = "20"
			up_po.disabled = false


func _on_button_pressed() -> void:
	if color_rect.visible:
		sprite_2d_3.scale = Vector2(0.6,0.6)
		spr1.show()
		spr2.show()
		spr3.show()
		color_rect.hide()
	else:
		if qualCart == 1:
			spr1.show()
			spr2.hide()
			spr3.hide()
			sprite_2d_3.scale = Vector2(1,1)
			color_rect.show()
		if qualCart == 2:
			spr1.hide()
			spr2.show()
			spr3.hide()
			sprite_2d_3.scale = Vector2(1,1)
			color_rect.show()
		if qualCart == 3:
			spr1.hide()
			spr2.hide()
			spr3.show()
			sprite_2d_3.scale = Vector2(1,1)
			color_rect.show()


func _on_up_vi_pressed() -> void:

	if qualCart == 1:
		if Gobla.vidaDaCart1 >= 3:
			return

		var upVALo = int(up_vi.text)

		if upVALo <= Gobla.PontoDePar:
			Gobla.PontoDePar -= upVALo
			Gobla.vidaDaCart1 += 1

	elif qualCart == 2:
		if Gobla.vidaDaCart2 >= 3:
			return

		var upVALo = int(up_vi.text)

		if upVALo <= Gobla.PontoDePar:
			Gobla.PontoDePar -= upVALo
			Gobla.vidaDaCart2 += 1

	elif qualCart == 3:
		if Gobla.vidaDaCart3 >= 3:
			return

		var upVALo = int(up_vi.text)

		if upVALo <= Gobla.PontoDePar:
			Gobla.PontoDePar -= upVALo
			Gobla.vidaDaCart3 += 1


func _on_up_po_pressed() -> void:
	if qualCart == 1:
		if Gobla.DanoDaCart1 >= 3:
			return

		var upVALo = int(up_po.text)

		if upVALo <= Gobla.PontoDePar:
			Gobla.PontoDePar -= upVALo
			Gobla.DanoDaCart1 += 1

	elif qualCart == 2:
		if Gobla.DanoDaCart2 >= 3:
			return

		var upVALo = int(up_po.text)

		if upVALo <= Gobla.PontoDePar:
			Gobla.PontoDePar -= upVALo
			Gobla.DanoDaCart2 += 1

	elif qualCart == 3:
		if Gobla.DanoDaCart3 >= 3:
			return

		var upVALo = int(up_po.text)

		if upVALo <= Gobla.PontoDePar:
			Gobla.PontoDePar -= upVALo
			Gobla.DanoDaCart3 += 1
