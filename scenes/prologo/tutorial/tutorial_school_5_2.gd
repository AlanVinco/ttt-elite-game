extends Node2D

@onready var player = $player
@onready var irla = $irla_player
@export var TextScene : PackedScene
@onready var breef = $Breef

var ACTO = 1
var dialogs = []
var win

@onready var opciones_scene = preload("res://scenes/options_layer.tscn")
var opciones_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$teacher.play("idle")
	MusicManager.music_player["parameters/switch_to_clip"] = "SCENE THEME"
	MusicManager.music_player.play()
	player.limit_left = -345
	player.limit_right = 654
	player.move = false
	#quitar
	ReputationManager.modify_reputation("IRLA", -10)
	check_status()

func check_status():
	if ReputationManager.get_reputation("IRLA") < 100:
		win = true
		MusicManager.music_player["parameters/switch_to_clip"] = "MISTERY THEME"
		await get_tree().create_timer(1.0).timeout
		player.start_camera_shake(0.5, 10.0)
		dialogs = ["¿QUEEEE?", "!HICISTE TRAMPA!", "¿COMO PUDISTE VENCERME?",
		"!ESTO ES IMPOSIBLE!",]
		create_text(dialogs,"IRLA", "NORMAL")
	else:
		win = false
		dialogs = ["Jajaja", "Sabia que seguirias siendo igual de malo.",
		"No has mejorado nada.", "Largate antes de que me des mas asco."]
		create_text(dialogs,"IRLA", "NORMAL")

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
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["¿Que carajos?"]
				create_text(dialogs,"OLVIRA", "NORMAL")
			else:
				print("terminar escena.")
		2:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["¿Pero que mierda?"]
				create_text(dialogs,"BREEF", "NORMAL")
		3:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["¿WTF?"]
				create_text(dialogs,"ARLETTA", "NORMAL")
		4:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Impresionante."]
				create_text(dialogs,"OTZIRI", "NORMAL")
		5:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Wow, lo logro."]
				create_text(dialogs,"CHIZU", "NORMAL")
		6:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Jajaja"]
				create_text(dialogs,"JOE", "NORMAL")
		7:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["No lo puedo creer.", "¿Como pudiste perder contra el Irla?",
				"En fin.", "Reglas son reglas.", "Exige tu recompensa."]
				create_text(dialogs,"TEACHER", "NORMAL")
		8:
			ACTO += 1
			if win:
				var nombres = ["Quitate la ropa", "Nada",]
				mostrar_opciones(nombres, "IRLANORMAL")
		10:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Reglas son reglas, tienes que obedecer.",]
				create_text(dialogs,"TEACHER", "NORMAL")
		11:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				$ropa.play()
				irla.reproducir_animacion_prioritaria("irla_faldabra_idle")
				
				dialogs = ["Eres un maldito.", "!Enfermo!",]
				create_text(dialogs,"IRLA", "SUETERNORMAL")
		12:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				irla.reproducir_animacion_prioritaria("irla_bra_panty_idle")
				dialogs = ["Como te odio...", "Y te desprecio.",]
				create_text(dialogs,"IRLA", "FALDANORMAL")
		13:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Mira que avergonzarme asi.", "Enfrente de todos.",]
				create_text(dialogs,"IRLA", "FALDANORMAL2")
		14:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				irla.reproducir_animacion_prioritaria("irla_bra_panty_idle")
				$ropa.play()
				dialogs = ["Me las vas a pagar.", "Idiota.",]
				create_text(dialogs,"IRLA", "INTERIOR")
		15:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Quita tu mano.", "Dejame verte bien.",]
				create_text(dialogs,"PLAYER", "NORMAL")
		16:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Listo imbecil.", "Ya me la quite.", "Ahora dejame en paz."]
				create_text(dialogs,"IRLA", "INTERIOR2")
		17:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Ja.", "No, no, no.", "!TODA LA ROPA!"]
				create_text(dialogs,"PLAYER", "NORMAL")
		18:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				player.start_camera_shake(0.5, 10.0)
				dialogs = ["!¿QUE?!", "¿ESTAS IDIOTA?", "YO NO VOY A HACER ESO.", "Olvidalo.", 
				"!Maestra por favor!", "!Detenga esto!"]
				create_text(dialogs,"IRLA", "INTERIOR2")
		19:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Lo siento Irla.", "Sabes cuales son las reglas.", 
				"Y debes obedecerlas.", "Al pie de la letra.", "Por eso, la importancia de este juego.",
				"Cada acción tiene su consecuencia.", "Y uno no sabe que es lo que exigirá el rival.", 
				"Como recompensa.", "Asi que te pedire que prosigas."]
				create_text(dialogs,"TEACHER", "NORMAL")
		20:
			ACTO += 1
			if win:
				await get_tree().create_timer(2.0).timeout
				$ropa.play()
				irla.reproducir_animacion_prioritaria("irla_nobra_panty_idle")
				dialogs = ["!Maldita sea!", "Pervertido.", "!Es lo peor que me ha pasado!", 
				"!Ojala te mueras!"]
				create_text(dialogs,"IRLA", "NUDE1")
				
		21:
			ACTO += 1
			if win:
				await get_tree().create_timer(2.0).timeout
				dialogs = ["!ALTO!",]
				create_text(dialogs,"BREEF", "NORMAL")
		22:
			ACTO += 1
			if win:
				MusicManager.music_player["parameters/switch_to_clip"] = "BREEF MAIN"
				breef.posicion_objetivo = Vector2(230, 117)
				breef.connect("llego_al_destino", Callable(self, "_accion_despues_de_llegar"))
		24:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Aww", "Gracias por defenderme Breef"]
				create_text(dialogs,"IRLA", "NUDE")
		25:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Ella es solo mia.",]
				create_text(dialogs,"BREEF", "NORMAL")
		26:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["¿Que?", "Yo no soy de nadie.", "Como sea.. sigue..."]
				create_text(dialogs,"IRLA", "NUDE")
		27:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["!Primero tendras que derrotarme!",]
				create_text(dialogs,"BREEF", "NORMAL")
		28:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["..............."]
				create_text(dialogs,"PLAYER", "NORMAL")
		29:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["!Hazlo pedazos Breef!"]
				create_text(dialogs,"IRLA", "NUDE")
		30:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				StartGame.create_game(5, "reputation", "BREEF", "easy", "res://scenes/prologo/tutorial/tutorial_school_5_3.tscn")

			
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
	cerrar_opciones()
	ACTO += 1 
	player.start_camera_shake(0.5, 10.0)
	dialogs = ["!!Que!!", "Ni lo sueñes.", "Yo no voy a hacer eso.", "Jodete."]
	create_text(dialogs,"IRLA", "NORMAL")  

func ejecutar_funcion_B():
	cerrar_opciones() 
	ACTO += 1
	dialogs = ["Hmm...", "Veo que todavia tienes un poco de desencia.", 
	"Igual eso no te quita lo malo que eres.", "Jodete."]
	print("Aumentar enamoramiento")
	create_text(dialogs,"IRLA", "NORMAL") 

func _accion_despues_de_llegar():
	ACTO +=1
	dialogs = ["!No permitire que te burles de Irla!",]
	create_text(dialogs,"BREEF", "NORMAL")
