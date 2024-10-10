extends Node2D

@onready var player = $player

@export var shake_intensidad: float = 5.0  # Intensidad del shake (en píxeles)
@export var shake_duracion: float = 0.5    # Duración total del shake en segundos
var shake_tiempo: float = 0.0              # Tiempo restante para el shake
var original_posicion: Vector2  
@export var TextScene : PackedScene
@export var player_Scene : PackedScene
var next_scene = "res://scenes/prologo/tutorial/tutorial_school_5.tscn"
var ACTO = 1

var dialogs = [] 

var music_player: AudioStreamPlayer

var  player_move

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTransition.changeModulate(0.2863, 0.2863, 0.2863, 1)	
	music_lopp()
	MusicManager.stop_music()	
	$CPUParticles2D.visible = true
	player.position = Vector2(173, 118)
	await get_tree().create_timer(2.0).timeout
	$thunder.play()
	await get_tree().create_timer(0.3).timeout
	iniciar_shake(1)
	await get_tree().create_timer(4.0).timeout
	dialogs = ["¿Te piensas quedar ahi tirado?","Levantate.",]
	create_text(dialogs, "DEMON", "NORMAL")

func shake_efecto():
	# Aplicar una sacudida aleatoria en X e Y
	var offset_x = randf_range(-shake_intensidad, shake_intensidad)
	var offset_y = randf_range(-shake_intensidad, shake_intensidad)
	position = original_posicion + Vector2(offset_x, offset_y)

# Función para iniciar el shake
func iniciar_shake(duracion: float):
	shake_duracion = duracion
	shake_tiempo = duracion

func _process(delta):
	if shake_tiempo > 0:
		shake_tiempo -= delta
		shake_efecto()
	else:
		position = original_posicion  # Volver a la posición original


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
			acto_2()
		2:
			acto_3()
		3:
			acto_4()
		4:
			acto_5()
		5:
			acto_6()
		6:
			acto_7()
		7:
			acto_8()
		8:
			acto_9()
		9:
			acto_10()
		10:
			acto_11()
		_:
			get_tree().change_scene_to_file(next_scene)
			player_move.queue_free()
			
func acto_2():
	ACTO +=1
	$CanvasDemon/ColorRect.visible = true
	$CanvasDemon/TextureRect.visible = true
	await get_tree().create_timer(2.0).timeout
	dialogs = ["Das pena chico.", "No puedes seguir dejando que te traten asi.",
	"Demuestrales que no eres un idiota.",]
	create_text(dialogs, "DEMON", "NORMAL")

func acto_3():
	ACTO +=1
	dialogs = ["...", "¿Quien eres?"]
	create_text(dialogs, "PLAYER", "NORMAL")
	
func acto_4():
	ACTO +=1
	dialogs = [ "JAJAJA...", "Digamos que...", "Alguien que cambiara tu vida.", "Para siempre."]
	create_text(dialogs, "DEMON", "NORMAL")
	
func acto_5():
	ACTO +=1
	dialogs = [ "¿Vienes a ayudarme?", "¿A mi?", "Si todos tienen razon...", "No sirvo para nada..", "Soy una basura.", "Yo me rindo."]
	create_text(dialogs, "PLAYER", "NORMAL")
	
func acto_6():
	ACTO +=1
	dialogs = [ "Ja...", "Y...", "¿Que estarias dispuesto a entregar para cambiar eso?",]
	create_text(dialogs, "DEMON", "NORMAL")

func acto_7():
	ACTO +=1
	dialogs = [ "...", "Daria cualquier cosa...", "Mi alma si es necesario...",]
	create_text(dialogs, "PLAYER", "NORMAL")
	
func acto_8():
	ACTO +=1
	dialogs = [ "¿Que harias si te diera un poco de mi poder?",]
	create_text(dialogs, "DEMON", "NORMAL")
	
func acto_9():
	ACTO +=1
	$CanvasDemon/ColorRect.visible = false
	$CanvasDemon/TextureRect.visible = false
	$Demond.visible = true
	$Demond.play("idle")
	await get_tree().create_timer(2.0).timeout
	dialogs = [ "Me vengaria de todas..", "Y cada una...", "de ellas..."]
	create_text(dialogs, "PLAYER", "NORMAL")
	
func acto_10():
	ACTO +=1
	dialogs = [ "!Excelente!", "Quiero verlo...", "Haz tus mas oscuros sueños realidad.", "Te estare vigilando."]
	create_text(dialogs, "DEMON", "NORMAL")

func acto_11():
	ACTO +=1
	await get_tree().create_timer(1.0).timeout
	$Demond.visible = false
	player.visible = false
	player_move = player_Scene.instantiate()
	player_move.position = Vector2(160, 127)
	get_parent().add_child(player_move)
	player_move.limit_right = 962
	player_move.limit_left = -795


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		dialogs = ["Que empiece el juego."]
		create_text(dialogs, "PLAYER", "NORMAL")


func music_lopp():
	music_player = $"DEMON THEME" # Asegúrate de que el path sea correcto

	if music_player == null:
		print("Error: Nodo AudioStreamPlayer no encontrado")
		return

	# Cargar el audio stream
	var audio_stream = load("res://music/DEMON THEME.mp3") as AudioStream
	if audio_stream == null:
		print("Error: No se pudo cargar el archivo de audio")
		return

	# Asegurarse de que el audio tenga la propiedad 'loop'
	if audio_stream.has_method("set_loop"):
		audio_stream.set_loop(true)  # Habilitar el loop
	else:
		print("El AudioStream no soporta loop")
	
	# Asignar el stream al AudioStreamPlayer y reproducir
	music_player.stream = audio_stream
	music_player.play()
