extends Node

@onready var label = $CanvasLayer/Label
@onready var label2 = $CanvasLayer/Label2

@onready var animatedTransition = $transition

var next_scene = "res://scenes/prologo/tutorial/tutorial_school_4.tscn"

#
var dialogs = [
	"Esta es mi historia.",
	"Dejenme presentarme.",]

var Acto = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	$AudioStreamPlayer2D.play()
	DialogManager.start_typing_effect(label, dialogs)
	DialogManager.connect("all_texts_displayed", Callable(self, "_on_all_texts_displayed"))

func acto_3():
	#Agregar transision
	$bg1.visible = false
	$player.visible = false
	DialogManager.start_typing_effect(label2, dialogos_actos[Actos.ACTO_3])

func acto_4():
		#Agregar transision
	$bg2.visible = false
	DialogManager.start_typing_effect(label2, dialogos_actos[Actos.ACTO_4])
	
func acto_5():
	#Agregar transision
	$bg3.visible = false
	$TextureRect.visible = false
	
	DialogManager.start_typing_effect(label2, dialogos_actos[Actos.ACTO_5])

#MEJORAS

enum Actos {
	ACTO_1,
	ACTO_2,
	ACTO_3,
	ACTO_4,
	ACTO_5
}

var current_acto = Actos.ACTO_1

var dialogos_actos = {
	Actos.ACTO_2: [
		"Mi nombre es Saenosuke Sagaraa y tengo 27 años.",
		"Estudio en la universidad de TTT.",
		"No tengo amigos y siempre estoy solo...",
		"Actualmente estoy a mitad del ciclo y no puedo salirme."
	],
	Actos.ACTO_3: [
		"En este instituto el deporte mas importante es el TTT.", 
		"Si eres bueno obtienes lo mejor de lo mejor.", 
		"Pero para mi mala suerte yo soy todo lo contrario..."
	],
	Actos.ACTO_4: ["Soy el peor jugador de TTT...", 
		"Jamas en mi vida he ganado un solo juego de TTT!", 
		"Lo cual ocaciona burlas y maltratos por parte mis compañeros...",
		"Para ellos soy la peor escoria que ha llegado a este instituto..." 
	],
	Actos.ACTO_5: ["Pero algun dia se que podre vengarme de...",
		"TODOS...", "Y..", 
		"CADA UNO...", 
		"DE ELLOS! "
	],
	# Añade más diálogos para los otros actos
}

func start_acto_dialogs(acto: Actos):
	DialogManager.start_typing_effect(label2, dialogos_actos[acto])

func _on_all_texts_displayed():
	print("Todos los textos han sido completados.")
	match current_acto:
		Actos.ACTO_1:
			label.visible = false
			change_act(Actos.ACTO_2)
		Actos.ACTO_2:
			change_act(Actos.ACTO_3)
		Actos.ACTO_3:
			change_act(Actos.ACTO_4)
		Actos.ACTO_4:
			change_act(Actos.ACTO_5)
		Actos.ACTO_5:
			label2.visible = false
			get_tree().change_scene_to_file(next_scene)

func change_act(new_acto):
	current_acto = new_acto
	match new_acto:
		Actos.ACTO_2:
			acto_2()
		Actos.ACTO_3:
			acto_3()
		Actos.ACTO_4:
			acto_4()
		Actos.ACTO_5:
			acto_5()

func play_transition_and_wait(duration: float = 2) -> void:
	animatedTransition.play("transition")
	await get_tree().create_timer(duration).timeout

func acto_2():
	play_transition_and_wait()
	DialogManager.start_typing_effect(label2, dialogos_actos[Actos.ACTO_2])

func set_visibility(bg_visible: bool, player_visible: bool):
	$bg1.visible = bg_visible
	$player.visible = player_visible
