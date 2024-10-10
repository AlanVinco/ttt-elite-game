extends Node2D

@onready var irlaCamera = $irla_player
@onready var irlaNpc = $irla_player2
@onready var teacher = $teacher
@export var TextScene : PackedScene
var dialogs = []
var ACTO = 1
@export var player: PackedScene
var player_move

@onready var opciones_scene = preload("res://scenes/options_layer.tscn")
var opciones_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "SCENE THEME"
	MusicManager.music_player.play()
	teacher.play("idle")
	irlaCamera.posicion_objetivo = Vector2(317, 90)
	irlaCamera.connect("llego_al_destino", Callable(self, "_accion_despues_de_llegar"))
	
	#irlaCamera.posicion_objetivo = Vector2(-175, 90)
	
	
func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	match ACTO:
		1:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Yo...", "No."]
			create_text(dialogs,"OLVIRA", "NORMAL")
		2:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Yo...", "Menos."]
			create_text(dialogs,"ARLETTA", "NORMAL")
		3:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Para la proxima mejor profesora.", "Todavia me falta mejorar."]
			create_text(dialogs,"OTZIRI", "NORMAL")
		4:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Hm...", "Yo todavia no me siento preparada."]
			create_text(dialogs,"CHIZU", "NORMAL")
		5:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			MusicManager.music_player["parameters/switch_to_clip"] = "IRLA MAIN"
			dialogs = ["!Yo Profesora!", "!Yo paso!"]
			create_text(dialogs,"IRLA", "NORMAL")
		6:
			ACTO += 1
			$SchoolRoom.visible = false
			irlaNpc.visible = true
			irlaCamera.posicion_objetivo = Vector2(44, 90)
			await get_tree().create_timer(7.0).timeout
			dialogs = ["Muy bien.", "Gracias por siempre participar."]
			create_text(dialogs,"TEACHER", "NORMAL")
			
		8:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Por nada.", "Sabe que soy la mejor en la clase.",
			"Y nadie puede superarme.", "Jajaja"]
			create_text(dialogs,"IRLA", "NORMAL")
		9:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["¿Quien quiere retar a su compañera a un duelo?",]
			create_text(dialogs,"TEACHER", "NORMAL")
		10:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["..."]
			create_text(dialogs,"OLVIRA", "NORMAL")
		11:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["..."]
			create_text(dialogs,"ARLETTA", "NORMAL")
		12:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["..."]
			create_text(dialogs,"OTZIRI", "NORMAL")
		13:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["..."]
			create_text(dialogs,"CHIZU", "NORMAL")
		14:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["..."]
			create_text(dialogs,"BREEF", "NORMAL")
		15:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["..."]
			create_text(dialogs,"JOE", "NORMAL")
		16:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["¿Nadie?"]
			create_text(dialogs,"TEACHER", "NORMAL")
		17:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["!YO!"]
			create_text(dialogs,"PLAYER", "NORMAL")
			irlaCamera.posicion_objetivo = Vector2(-175, 90)
		19:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Deja de hacer el ridiculo idiota."]
			create_text(dialogs,"BREEF", "NORMAL")
		20:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Mejor largate y deja de humillarte solo."]
			create_text(dialogs,"OLVIRA", "NORMAL")
		21:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Maldito fenomeno, solo vienes a arruinarnos el dia a todos."]
			create_text(dialogs,"ARLETTA", "NORMAL")
		22:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Mejor deberias sentarte compañero."]
			create_text(dialogs,"OTZIRI", "NORMAL")
		23:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["mhh.", "Por favor hazle caso a los demas."]
			create_text(dialogs,"CHIZU", "NORMAL")
		24:
			ACTO += 1
			await get_tree().create_timer(1.0).timeout
			dialogs = ["Silencio chicos.", "Su compañero tambien tiene derecho a participar.",
			"Apesar de lo inutil y malo que es.", "Recuerden las reglas.",
			"El ganador puede exigir la recompensa que desee sin objeción.",
			"Acabalo rapido para seguir con la clase.", "Oye todavia estas a tiempo de retractarte.",
			"¿Estas seguro que quieres retar a Irla?"]
			create_text(dialogs,"TEACHER", "NORMAL")
		25:
			var nombres = ["Desafiar", "Rechazar",]
			mostrar_opciones(nombres, "IRLANORMAL")
		26:
			#NO QUISO PELEAR
			print("TERMINAR ESCENA.")
			
func _accion_despues_de_llegar():
	if ACTO == 1:
		await get_tree().create_timer(1.0).timeout
		dialogs = ["Buenos dias clase.", "Hoy retomaremos la sesión que vimos ayer.",
		"¿Quien quiere pasar a mostrarnos su técnica?"]
		create_text(dialogs,"TEACHER", "NORMAL")
	if ACTO == 7:
		ACTO += 1
		await get_tree().create_timer(1.0).timeout
		irlaCamera.posicion_objetivo = Vector2(317, 90)
		irlaNpc.posicion_objetivo = Vector2(317, 122)
	if ACTO == 18:
		irlaCamera.queue_free()
		$Risas.play()
		player_move = player.instantiate()
		player_move.position = Vector2(-175, 130)
		get_parent().add_child(player_move)
		player_move.limit_left = -345
		player_move.limit_right = 654


func _on_area_2d_body_entered(body: Node2D) -> void:
	ACTO += 1
	player_move.move = false
	dialogs = ["Jajajaja", "¿Tu?", "Por favor no me hagas reir.",
	"Ayer te di una paliza.", "No seas patetico.", "¿Que acaso no aprendiste?", 
	"¿Cuando entenderas que no sirves para nada?"]
	create_text(dialogs,"IRLA", "NORMAL")
	

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
	player_move.queue_free()
	cerrar_opciones()  
	MusicManager.music_player["parameters/switch_to_clip"] = "IRLA BATTLE"
	StartGame.create_game(10, "reputation", "IRLA", "easy", "res://scenes/prologo/tutorial/tutorial_school_5_2.tscn")

func ejecutar_funcion_B():
	cerrar_opciones() 
	ACTO += 1 
	dialogs = ["JAJAJA", "Sabia que te daria miedo.", "Asi o mas patetico.", "Largate inutil."]
	create_text(dialogs,"IRLA", "NORMAL")
