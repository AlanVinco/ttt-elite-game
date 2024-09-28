extends Node2D

@onready var sprite = $player  # Referencia al Sprite2D
@export var velocidad: float = 400.0  # Velocidad de movimiento
var posicion_objetivo: Vector2 = Vector2(173, 118)  # Posición a la que se moverá el sprite
var mover_sprite: bool = false  # Controla si se debe mover el sprite

#SHAKE

@export var shake_intensidad: float = 5.0  # Intensidad del shake (en píxeles)
@export var shake_duracion: float = 0.5    # Duración total del shake en segundos
var shake_tiempo: float = 0.0              # Tiempo restante para el shake
var original_posicion: Vector2             # Posición original antes del shake

var next_scene = "res://scenes/prologo/tutorial/tutorial_school_3.tscn"

@onready var audio_player = $AudioStreamPlayer2D  # O referencia al AudioStreamPlayer2D globalmente

func _ready() -> void:
	$CPUParticles2D.visible = true
	sprite.play("down")
	await get_tree().create_timer(0.65).timeout
	iniciar_shake(0.2)
	await get_tree().create_timer(2).timeout
	MusicManager.music_player["parameters/switch_to_clip"] = "RAIN THEME"
	MusicManager.music_player.play()
	
	await get_tree().create_timer(15.0).timeout
	$animationScene.play("transition_end")
	fade_out(3.0)
	await get_tree().create_timer(3).timeout
	$CanvasModulate.color = "000000"
	get_tree().change_scene_to_file(next_scene)

func _process(delta):
	mover_hacia_objetivo(delta)
	if shake_tiempo > 0:
		shake_tiempo -= delta
		shake_efecto()
	else:
		position = original_posicion  # Volver a la posición original

func mover_hacia_objetivo(delta):
	var distancia = posicion_objetivo - sprite.position

	if distancia.length() > 1:  # Si está lejos del objetivo
		var direccion = distancia.normalized()
		sprite.position += direccion * velocidad * delta
	else:
		sprite.position = posicion_objetivo  # Fijar posición exacta al llegar
		mover_sprite = false  # Detener el movimiento

# Función para iniciar el movimiento hacia una posición específica
func iniciar_movimiento(nueva_posicion: Vector2):
	posicion_objetivo = nueva_posicion
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


# Función para realizar un fade-out
func fade_out(duration: float) -> void:
	var initial_volume = audio_player.volume_db
	var steps = 20  # Número de pasos para el fade
	var step_time = duration / steps  # Tiempo entre cada paso

	for i in range(steps):
		# Disminuir el volumen en cada paso, asegúrate de que -80 es un float (-80.0)
		audio_player.volume_db = lerp(initial_volume, -80.0, float(i) / float(steps))  # -80.0 dB es volumen mínimo
		await get_tree().create_timer(step_time).timeout  # Espera entre cada paso

	# Detener la música cuando el fade-out termina
	audio_player.stop()
