extends Node2D

@onready var playerAnimations = $PlayerAnimations
@onready var Irla = $irla_player
@onready var animationsScene = $AnimationScene

@onready var Breef = $Breef

@export var TextScene : PackedScene

@export var velocidad: float = 100.0  # Velocidad en píxeles por segundo

var Acto = 0

var next_scene = "res://scenes/prologo/tutorial/tutorial_school_2.tscn"

var dialogs = ["Eres un desastre!", "No puedo creer lo malo que eres..."]

var posicion_objetivo: Vector2 = Vector2.ZERO  # Posición a la que queremos que se mueva
var mover_sprite: bool = false  # Variable que controla si se debe mover el sprite
# Called when the node enters the scene tree for the first time.

var posicion_objetivo_x: float = 0.0 

##SHAKE

@export var shake_intensidad: float = 5.0  # Intensidad del shake (en píxeles)
@export var shake_duracion: float = 0.5    # Duración total del shake en segundos
var shake_tiempo: float = 0.0              # Tiempo restante para el shake
var original_posicion: Vector2             # Posición original antes del shake

func _ready() -> void:
	$irla_player/Label.visible = false
	$Breef/Label.visible = false
	$transitions.visible = true
	original_posicion = position  # Guardar la posición original
	playerAnimations.play("idle")
	animationsScene.play("transition")
	await get_tree().create_timer(1.5).timeout
	create_text(dialogs, "IRLA", "NORMAL")

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)
	
func _on_finished_displaying():
	print("Un texto ha sido terminado.")

func _on_all_texts_displayed():
	print("Todos los textos han sido completados.")
	match Acto:
		0:
			acto_1()
		1:
			acto_2()
		2:
			acto_3()
		_:
			print("Agregar final")

func acto_1():
	Acto = 1
	#Breef.direccion = Vector2.LEFT
	Breef.posicion_objetivo = Vector2(129, 116)
	Breef.connect("llego_al_destino", Callable(self, "_accion_despues_de_llegar"))
	Breef.connect("animacion_prioritaria_terminada", Callable(self, "_accion_despues_de_animacion"))
#
func _accion_despues_de_llegar():
	if Acto == 1:
		#$IRLA_MAIN.playing = false
		#$BREEF_MAIN.playing = true
		#audioManager["parameters/switch_to_clip"] = "BREEF MAIN"
		MusicManager.music_player["parameters/switch_to_clip"] = "BREEF MAIN"
		dialogs = ["¿Que pasa aqui?", "¿Te esta molestando este idiota?", "No es mas que una basura.",
		"Jajaja", "......", "Tu simple prescencia nos da asco...", "LARGATE DE AQUI!!!"]
		create_text(dialogs, "BREEF", "NORMAL")
	# Aquí puedes realizar la acción que desees ejecutar después

func acto_2():
	Breef.reproducir_animacion_prioritaria("punch")
	#Breef.animacion.play("punch")

func _accion_despues_de_animacion():
	print("La animación prioritaria ha terminado. Realizando acción...")
	playerAnimations.play("golpeado1")
	iniciar_shake(0.2)
	iniciar_movimiento_hacia_izquierda(100)
	await get_tree().create_timer(2.0).timeout 
	end_breef()
	# Aquí puedes poner la lógica que quieras ejecutar cuando la animación termine


func _on_player_animations_animation_finished() -> void:
	playerAnimations.play("golpeado2")

func _process(delta):
	if mover_sprite:
		mover_hacia_la_izquierda(delta)
	if shake_tiempo > 0:
		shake_tiempo -= delta
		shake_efecto()
	else:
		position = original_posicion  # Volver a la posición original

func mover_hacia_la_izquierda(delta):
	playerAnimations.position.x -= 150 * delta 
	playerAnimations.position.y -= 150 * delta 
# Función para iniciar el movimiento
func iniciar_movimiento_hacia_izquierda(nueva_posicion_x: float):
	posicion_objetivo_x = nueva_posicion_x
	mover_sprite = true  # Activar el movimiento

func shake_efecto():
	# Aplicar una sacudida aleatoria en X e Y
	var offset_x = randf_range(-shake_intensidad, shake_intensidad)
	var offset_y = randf_range(-shake_intensidad, shake_intensidad)
	position = original_posicion + Vector2(offset_x, offset_y)

# Función para iniciar el shake
func iniciar_shake(duracion: float):
	shake_duracion = duracion
	shake_tiempo = duracion

func end_breef():
	Acto = 2 
	dialogs = ["Con eso aprendera...", "Vamonos."]
	create_text(dialogs, "BREEF", "NORMAL")

func acto_3():
	Breef.posicion_objetivo = Vector2(413, 120)
	Irla.posicion_objetivo = Vector2(413, 120)
	await get_tree().create_timer(2).timeout
	animationsScene.play("end_transition")
	await get_tree().create_timer(2).timeout
	MusicManager.stop_music()
	get_tree().change_scene_to_file(next_scene)
