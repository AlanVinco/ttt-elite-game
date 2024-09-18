extends Node2D

@onready var Irla = $irla_player
@onready var player = $player

@export var next_scene : PackedScene

@onready var pervert_joe = $"Pervert Joe"
@onready var buttonJoe = $Button

@export var TextScene : PackedScene

var dialogs = []
@export var check_irla_action = ""

@export var door_bathroom = false

func _ready() -> void:
	ReputationManager.register_npc("JOE")

	player.limit_left = -730
	player.limit_right = 750
	GlobalTime.irla_bathroom.connect(self._irla_bathroom)
	Irla.connect("llego_al_destino", Callable(self, "_accion_despues_de_llegar"))
	#Breef.connect("animacion_prioritaria_terminada", Callable(self, "_accion_despues_de_animacion"))
	MusicManager.music_player["parameters/switch_to_clip"] = "CLASSROOM THEME"
	if MusicManager.music_player.playing == false:
		MusicManager.music_player.play()
		
	if GlobalTime.IRLA_ACTION == "GO TO BATHROOM":
		_irla_bathroom()
		
	if ReputationManager.get_reputation("JOE") < 100:
		$Button.visible = false
		player.global_position.x = -550
		dialogs=["¿Como pudiste vencerme?", "Bueh...", "Aqui esta la llave. Disfrutala."]
		await get_tree().create_timer(0.5).timeout
		create_text(dialogs, "JOE", "NORMAL")
		GlobalItems.get_key()
		

func _irla_bathroom():
	await get_tree().create_timer(1.0).timeout
	Irla.visible = true
	Irla.posicion_objetivo = Vector2(-544, 120)
	
func _accion_despues_de_llegar():
	await get_tree().create_timer(1.0).timeout
	Irla.visible = false
	GlobalTime.change_irla_actions("IN BATHROOM")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		buttonJoe.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		buttonJoe.visible = false

func _on_button_pressed() -> void:
	check_irla_action = GlobalTime.IRLA_ACTION
	
	if check_irla_action == "IN BATHROOM":
		dialogs = ["¿Quieres entrar al baño de mujeres?", "Ja,",
		"Yo tengo la llave.", "Si la quieres tendras que vencerme."]
	else:
		dialogs = ["¿Que miras?", "Largate idiota."]
	create_text(dialogs, "JOE", "NORMAL")

func create_text(texto, character, emotion) -> void:
	player.move = false
	buttonJoe.visible = false
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	##
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)
	
func _on_all_texts_displayed():
	player.move = true
	if check_irla_action == "IN BATHROOM":
		$CanvasOptions.visible = true
		print("Modal de pelea")


func _on_woman_bathroom_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$womanBathroom/BahtroomButton.visible = true

func _on_woman_bathroom_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$womanBathroom/BahtroomButton.visible = false

func _on_bahtroom_button_pressed() -> void:
	$womanBathroom/BahtroomButton.visible = false
	if GlobalItems.KEYS == 1:
		door_bathroom = true
		
	if door_bathroom == true:
		GlobalTransition.door_open_sound()
		dialogs=["Esta abierta."]
		create_text(dialogs, "PLAYER", "NORMAL")
		get_tree().change_scene_to_packed(next_scene) 
	else:
		GlobalTransition.door_lock()
		dialogs=["Esta cerrada."]
		create_text(dialogs, "PLAYER", "NORMAL")

func _on_button_acept_pressed() -> void:
	$CanvasOptions.visible = false
	MusicManager.music_player["parameters/switch_to_clip"] = "JOE BATTLE"
	StartGame.create_game(5, "reputation", "JOE", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn")

func _on_button_decline_pressed() -> void:
	$CanvasOptions.visible = false