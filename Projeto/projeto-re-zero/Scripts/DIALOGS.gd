extends CanvasLayer


const DIALOG_SCREEEN: PackedScene = preload("res://Scenas/dialog.tscn")
@export_category("Objects")
@export var hud: CanvasLayer = null

var DialogChefeDia1: Dictionary = {
	0: {
		"dialog": "Aonde eu estou?",
		"title": "Subaru",
			},
	1: {
		"dialog": "Isso é a Torre de Pleiades... Como diabos eu vim parar aqui?",
		"title": "Subaru",
		
	},
	2: {
		"dialog": "Tá tipo ar tipo er tipo nada ver... Não vou fazer muitas perguntas. Meu objetivo é subir até o topo dessa torre. Com os meus amigos, vou enfrentar todos que estiverem na minha frente.",
		"title": "Subaru",
	
	},
	3: {
		"dialog": "Não importa se forem Bispos do Pecado ou Bruxas. Qualquer inimigo que vier pela frente, eu vou vencer. E se eu morrer... é só recomeçar.",
		"title": "Subaru",
			},
	4: {
		"dialog": "Pronto. Esse é o meu objetivo.",
		"title": "Subaru",
			},
	5: {
		"dialog": "Tutorial: para abrir e ver quais cartas você possui, aperte \"R\". Aqui também haverá uma lojinha para você melhorar suas cartas.",
		"title": "Tutorial",
		
	},
	6: {
		"dialog": "As cartas serão o seu principal meio de subir por toda essa torre. Então, escolha suas cartas com cuidado.",
		"title": "Tutorial",
		
			},
	7: {
		"dialog": "Boa sorte! Enfrente 5 inimigos até chegar ao topo da torre.",
		"title": "Tutorial",
		"icone": "res://EuBraBo/Sprites/icones/PatraoIcone.png"
	},
	8: {
		"dialog": "Você possui uma habilidade chamada RETORNO. Para ativá-la, você precisa morrer algumas vezes.",
		"title": "Tutorial",
		
	},
	9: {
		"dialog": "Depois de morrer, basta apertar \"T\". Pronto! Suas cartas serão trocadas e você poderá tentar novamente.",
		"title": "Tutorial",
		
	}
}

var DialogPetelgeuse: Dictionary = {
	0: {
		"dialog": "VOCÊ... VOCÊ CHEGOU ATÉ AQUI?! Que surpresa! Que maravilhosamente desesperador!",
		"title": "Petelgeuse",
		"icone": "res://EuBraBo/Sprites/icones/PetelgeuseIcone.png"
	},
	1: {
		"dialog": "Você não entende? Esta torre não pertence a você! Você não possui o direito de continuar subindo!",
		"title": "Petelgeuse",
		"icone": "res://EuBraBo/Sprites/icones/PetelgeuseIcone.png"
	},
	2: {
		"dialog": "Não importa quantas vezes você tente... eu vou esmagar sua determinação!",
		"title": "Subaru",
		"icone": "res://EuBraBo/Sprites/icones/iconeDoProta.png"
	},
	3: {
		"dialog": "Então venha! Mostre-me quantas vezes você consegue se levantar depois de cair!",
		"title": "Petelgeuse",
		"icone": "res://EuBraBo/Sprites/icones/PetelgeuseIcone.png"
	}
}

var DialogRegulus: Dictionary = {
	0: {
		"dialog": "Que absurdo. Você realmente acha que pode passar por mim?",
		"title": "Regulus",
		"icone": "res://EuBraBo/Sprites/icones/RegulusIcone.png"
	},
	1: {
		"dialog": "Eu não permitirei que alguém como você interrompa minha caminhada. Afinal, quem lhe deu esse direito?",
		"title": "Regulus",
		"icone": "res://EuBraBo/Sprites/icones/RegulusIcone.png"
	},
	2: {
		"dialog": "Direito? Eu não preciso de permissão para subir essa torre. Vou chegar ao topo, custe o que custar!",
		"title": "Subaru",
		"icone": "res://EuBraBo/Sprites/icones/iconeDoProta.png"
	},
	3: {
		"dialog": "Então você escolheu desafiar alguém que não pode ser derrotado. Que decisão lamentável.",
		"title": "Regulus",
		"icone": "res://EuBraBo/Sprites/icones/RegulusIcone.png"
	}
}

var DialogEchidna: Dictionary = {
	0: {
		"dialog": "Oh? Então você finalmente chegou. Eu estava bastante curiosa para saber quando você apareceria.",
		"title": "Echidna",
		"icone": "res://EuBraBo/Sprites/icones/EchidnaIcone.png"
	},
	1: {
		"dialog": "Diga-me, Subaru... o que exatamente você espera encontrar no topo dessa torre?",
		"title": "Echidna",
		"icone": "res://EuBraBo/Sprites/icones/EchidnaIcone.png"
	},
	2: {
		"dialog": "Eu não sei. Mas sei que não vou parar antes de descobrir.",
		"title": "Subaru",
		"icone": "res://EuBraBo/Sprites/icones/iconeDoProta.png"
	},
	3: {
		"dialog": "Que resposta interessante... Talvez sua determinação seja ainda mais valiosa do que eu imaginava.",
		"title": "Echidna",
		"icone": "res://EuBraBo/Sprites/icones/EchidnaIcone.png"
	}
}

var DialogElsa: Dictionary = {
	0: {
		"dialog": "Que surpresa... você conseguiu chegar até aqui.",
		"title": "Elsa",
		"icone": "res://EuBraBo/Sprites/icones/ElsaIcone.png"
	},
	1: {
		"dialog": "Mas não se preocupe. Eu prometo que farei sua morte ser rápida.",
		"title": "Elsa",
		"icone": "res://EuBraBo/Sprites/icones/ElsaIcone.png"
	},
	2: {
		"dialog": "Eu já morri antes. E mesmo assim, continuo aqui. Então não vou deixar você me parar.",
		"title": "Subaru",
		"icone": "res://EuBraBo/Sprites/icones/iconeDoProta.png"
	},
	3: {
		"dialog": "Hehe... então vamos descobrir quantas vezes você consegue sobreviver.",
		"title": "Elsa",
		"icone": "res://EuBraBo/Sprites/icones/ElsaIcone.png"
	}
}

var DialogDaphne: Dictionary = {
	0: {
		"dialog": "Você veio até aqui... então deve estar com muita fome.",
		"title": "Daphne",
		"icone": "res://EuBraBo/Sprites/icones/DaphneIcone.png"
	},
	1: {
		"dialog": "Todos sentem fome. Todos precisam comer. Então... por que não deixar meus queridos filhos comerem você?",
		"title": "Daphne",
		"icone": "res://EuBraBo/Sprites/icones/DaphneIcone.png"
	},
	2: {
		"dialog": "Eu realmente preferia não virar comida de ninguém, obrigado!",
		"title": "Subaru",
		"icone": "res://EuBraBo/Sprites/icones/iconeDoProta.png"
	},
	3: {
		"dialog": "Que pena... eles já estão com fome.",
		"title": "Daphne",
		"icone": "res://EuBraBo/Sprites/icones/DaphneIcone.png"
	}
}



func _ready() -> void:
	if Gobla.passoTuTorial:
		dialogDiarioAbri(DialogChefeDia1)



func dialogDiarioAbri(nome) -> void:
	var dialog: DialogScren = DIALOG_SCREEEN.instantiate()
	dialog.data = nome
	get_tree().paused = true
	#Gobla.passoTuTorial = false
	hud.add_child(dialog)
