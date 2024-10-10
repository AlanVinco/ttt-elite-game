extends Node2D

@onready var player = $player
@onready var irla = $irla_player
@export var TextScene : PackedScene
@onready var breef = $Breef
var next_scene = "res://scenes/chapter_1/day1/chapter_1_day_1.tscn"

var ACTO = 1
var dialogs = []
var win

@onready var opciones_scene = preload("res://scenes/options_layer.tscn")
var opciones_instance

func _ready() -> void:
	$teacher.play("idle")
	irla.show_options = false
	breef.show_options = false
	irla.reproducir_animacion_prioritaria("irla_nobra_panty_idle")
	MusicManager.music_player["parameters/switch_to_clip"] = "SCENE THEME"
	MusicManager.music_player.play()
	player.limit_left = -345
	player.limit_right = 654
	player.move = false
	#quitar
	ReputationManager.modify_reputation("BREEF", -10)
	check_status()

func check_status():
	if ReputationManager.get_reputation("BREEF") < 100:
		breef.reproducir_animacion_prioritaria("lose")
		win = true
		MusicManager.music_player["parameters/switch_to_clip"] = "MISTERY THEME"
		await get_tree().create_timer(1.0).timeout
		player.start_camera_shake(0.5, 10.0)
		dialogs = ["¿COMO ES QUE PERDISTE?", "!ERES UN MALDITO INUTIL BREEF!", 
		"Por que tuve que creer en ti.",]
		create_text(dialogs,"IRLA", "NUDE")
	else:
		win = false
		dialogs = ["Ja.", "Te dije que no habia nada que temer.", "Solo tuvo un poco de suerte ese idiota.",
		"Ahora deja a Irla en paz y largate."]
		create_text(dialogs,"BREEF", "NORMAL")


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
				dialogs = ["Maldita sea.", "Nunca habia perdido.", "Y menos contra este animal.", 
				"¿Como pudo pasar esto?", "Si la tenia ganada.", "Te falle Irla..."]
				create_text(dialogs,"BREEF", "NORMAL")
			else:
				print("terminar escena.")
		2:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Ya se, no sirves para un carajo.", "Enserio no se por que confie en ti.", ]
				create_text(dialogs,"IRLA", "NUDE")
		3:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["No seas tan dura conmigo...", "Deseguro este idiota hizo trampa.", "No hay otra forma.", "En la que pudo haber ganado.",
				"!Si eso es!", "QUEDA ANUDALA SU VICTORIA", "POR TRAMPOSO", "!DAME LA REVANCHA MALDITO!"]
				create_text(dialogs,"BREEF", "NORMAL")
		4:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Lo siento Breef.", "Asi no son las reglas.", "A un que sea imposible de creer.",
				"Esta escoria gano.", "Ahora depende de el si va a parar esto.", "¿Que es lo que quieres?"]
				create_text(dialogs,"TEACHER", "NORMAL")
		5:
			ACTO += 1
			if win:
				var nombres = ["Desnudate Perra", "Estoy satisfecho, vistete.",]
				mostrar_opciones(nombres, "IRLANOBRA")
		7:
			ACTO += 1
			if win:
				irla.reproducir_animacion_prioritaria("irla_nude_idle")
				await get_tree().create_timer(1.0).timeout
				$ropa.play()
				dialogs = ["...................", "Ya estoy desnuda...", "¿Feliz?"]
				create_text(dialogs,"IRLA", "NAKED")
		8:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Dios.", "Que rica esta.",]
				create_text(dialogs,"BREEF", "NORMAL")
		9:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["LOL",]
				create_text(dialogs,"OLVIRA", "NORMAL")
		10:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Jaja WTF.",]
				create_text(dialogs,"ARLETTA", "NORMAL")
		11:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Esto no esta correcto, compañeros.",]
				create_text(dialogs,"OTZIRI", "NORMAL")
		12:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["No quiero ver esto.",]
				create_text(dialogs,"CHIZU", "NORMAL")
				
		13:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Joder, que cuerpo mas delicioso.",]
				create_text(dialogs,"JOE", "NORMAL")
		14:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["!CALLENSE TODOS!", "!TODOS ESTAN ENFERMOS!",
				"PERO MAS ESTE ASQUEROSO MALNACIDO", "!TERMINEMOS ESTO YA!"]
				create_text(dialogs,"IRLA", "NAKED")
		15:
			ACTO += 1
			if win:
				player.move = true
		16:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["Por fin...", "Termino esta tortura.",]
				create_text(dialogs,"IRLA", "NAKED")
		17:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				$ropa.play()
				irla.reproducir_animacion_prioritaria("idle")
				dialogs = ["No te me acerques, pervertido.", "No te quiero volver a ver.",]
				create_text(dialogs,"IRLA", "NORMAL")
		18:
			ACTO += 1
			if win:
				await get_tree().create_timer(1.0).timeout
				dialogs = ["A seguir con la clase.", "Saquen sus libros."]
				create_text(dialogs,"TEACHER", "NORMAL")
		19:
			ACTO += 1
			if win:
				print("Terminar escena")
				get_tree().change_scene_to_file(next_scene)
				
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
	player.start_camera_shake(3.0, 10.0)
	dialogs = ["!!MALDITA SEAAAAAAAAAA!!", "!DESNUDARME ENFRENTE DE TODOS!", 
	"¿POR QUE ME HACES ESTO?", "LES JURO..",  "QUE ME VENGARE DE ESTE DESGRACIADO."]
	create_text(dialogs,"IRLA", "NUDE")  

func ejecutar_funcion_B():
	cerrar_opciones() 
	ACTO += 1
	dialogs = ["Hmm...", "Veo que todavia tienes un poco de desencia.", 
	"Igual eso no te quita lo malo que eres.", "Jodete."]
	print("Aumentar enamoramiento")
	create_text(dialogs,"IRLA", "NORMAL") 


func _on_areabutton_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$irla_player/areabutton/Button.visible = true

func _on_areabutton_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$irla_player/areabutton/Button.visible = false

func _on_button_pressed() -> void:
	$irla_player/areabutton/Button.visible = false
	player.move = false
	await get_tree().create_timer(1.0).timeout
	MusicManager.stop_music()
	$Bell.play()
	await get_tree().create_timer(3.0).timeout
	MusicManager.music_player["parameters/switch_to_clip"] = "SCENE THEME"
	MusicManager.music_player.play()
	var dialogs = ["Muy bien chicos.", "Termino el tiempo."]
	create_text(dialogs,"TEACHER", "NORMAL")
