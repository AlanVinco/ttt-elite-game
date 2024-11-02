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

@onready var opciones_scene = preload("res://scenes/options_layer.tscn")
var opciones_instance

var can_enter_main_classroom = false

var scenes = {
	"classA": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"patio": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_patio.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"salida": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_salida.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"elevador": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_pasillo_2.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"men_bath":{
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_men_bathroom.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	}
}

func _ready() -> void:
	ReputationManager.register_npc("JOE")
	scenes["classA"]["button"] = $ClassroomDoor/Btn_entrar_claseA
	scenes["patio"]["button"] = $PatioDoor/Btn_Salir_patio
	scenes["salida"]["button"] = $salidaDoor/Btn_Salida
	scenes["elevador"]["button"] = $elevadorDoor/Btn_elevador
	scenes["men_bath"]["button"] = $menBathDoor/Btn_entrar_claseA
	#Posicion player
	if GlobalTransition.player_position_hallway != Vector2():
		player.position = GlobalTransition.player_position_hallway

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
		
	if ReputationManager.get_reputation("JOE") < 100 and GlobalTime.JOE_ACTION == "SPY" :
		$Button.visible = false
		player.global_position.x = -580
		dialogs=["¿Como pudiste vencerme?", "Bueh...", "Aqui esta la llave. Disfrutala."]
		await get_tree().create_timer(0.5).timeout
		create_text(dialogs, "JOE", "NORMAL")
		GlobalItems.get_key()
		GlobalTime.JOE_ACTION = "LOSE"
	# Conectar señales dinámicamente
	for door_name in scenes.keys():
		var button = scenes[door_name]["button"]
		var door = button.get_parent()

		if door and is_instance_valid(door):
			door.connect("body_entered", Callable(self, "_on_door_body_entered").bind(door_name))
			door.connect("body_exited", Callable(self, "_on_door_body_exited").bind(door_name))
		
		# Conectar la señal "pressed" del botón directamente
		if button and is_instance_valid(button):
			button.connect("pressed", Callable(self, "_on_btn_entrar_pressed").bind(door_name))

func _irla_bathroom():
	await get_tree().create_timer(1.0).timeout
	Irla.visible = true
	Irla.posicion_objetivo = Vector2(-544, 120)
	
func _accion_despues_de_llegar():
	await get_tree().create_timer(1.0).timeout
	Irla.visible = false
	GlobalTransition.door_open_sound()
	GlobalTime.change_irla_actions("IN BATHROOM")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		buttonJoe.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		buttonJoe.visible = false

func _on_button_pressed() -> void:
	check_irla_action = GlobalTime.IRLA_ACTION
	print(GlobalTime.JOE_ACTION)
	
	if check_irla_action == "IN BATHROOM" and GlobalTime.JOE_ACTION == "SPY":
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
	if check_irla_action == "IN BATHROOM" and GlobalTime.JOE_ACTION == "SPY":
		var nombres = ["Aceptar", "Rechazar",]
		mostrar_opciones(nombres, "JOE")

func _on_woman_bathroom_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$womanBathroom/BahtroomButton.visible = true

func _on_woman_bathroom_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$womanBathroom/BahtroomButton.visible = false

func _on_bahtroom_button_pressed() -> void:
	$womanBathroom/BahtroomButton.visible = false
	if GlobalItems.KEYS >= 1:
		door_bathroom = true
		
	if door_bathroom == true:
		GlobalTransition.door_open_sound()
		GlobalTransition.player_position_hallway = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_packed(next_scene) 
	else:
		GlobalTransition.door_lock()
		dialogs=["Esta cerrada."]
		create_text(dialogs, "PLAYER", "NORMAL")

func _on_button_acept_pressed() -> void:
	$CanvasOptions.visible = false
	MusicManager.music_player["parameters/switch_to_clip"] = "JOE BATTLE"
	GlobalTransition.player_position_hallway = player.position
	StartGame.create_game(5, "reputation", "JOE", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn")

func _on_button_decline_pressed() -> void:
	$CanvasOptions.visible = false

#OPCIONES 
# Función para generar botones en la escena de opciones con nombres personalizados
func mostrar_opciones(nombres_botones: Array, npc):
	opciones_instance = opciones_scene.instantiate()
	add_child(opciones_instance)
	
	# Pasar la lista de nombres de los botones a la escena de opciones
	opciones_instance.generar_botones(nombres_botones, npc)
	
	# Conectar la señal que emitirá la escena Opciones
	opciones_instance.connect("boton_presionado", Callable(self, "_on_boton_presionado"))

# Función que se llama cuando se presiona un botón
func _on_boton_presionado(indice: int):
	match indice:
		0:
			ejecutar_funcion_A()
		1:
			ejecutar_funcion_B()

# Función para cerrar la escena de opciones
func cerrar_opciones():
	if opciones_instance:
		opciones_instance.cerrar_opciones()  # Llama al método para liberar la escena de opciones
		opciones_instance = null  # Limpiar la referencia después de eliminar la instancia

# Ejemplos de funciones vinculadas a los botones
func ejecutar_funcion_A():
	MusicManager.music_player["parameters/switch_to_clip"] = "JOE BATTLE"
	StartGame.create_game(5, "reputation", "JOE", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn")
	cerrar_opciones()  # Cerrar opciones después de ejecutar la función A

func ejecutar_funcion_B():
	cerrar_opciones()  # Cerrar opciones después de ejecutar la función B

func _on_door_body_entered(body: Node2D, door_name: String) -> void:
	if body.is_in_group("player_group") and scenes.has(door_name):
		scenes[door_name]["button"].visible = true

func _on_door_body_exited(body: Node2D, door_name: String) -> void:
	if body.is_in_group("player_group") and scenes.has(door_name):
		scenes[door_name]["button"].visible = false

func _on_btn_entrar_pressed(door_name: String) -> void:
	if scenes.has(door_name):
		if door_name == "elevador":
			GlobalTransition.elevador_sound()
		else:
			GlobalTransition.door_open_sound()
		GlobalTransition.player_position_hallway = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scenes[door_name]["scene_path"])
