extends CharacterBody2D

signal llego_al_destino
signal animacion_prioritaria_terminada  # Nueva señal

@export var velocidad: float = 200.0
var direccion: Vector2 = Vector2.ZERO
var posicion_objetivo: Vector2 = Vector2.ZERO
var animacion_prioritaria = false  # Para bloquear otras animaciones durante la prioritaria
@onready var animacion = $AnimatedSprite2D

func _ready():
	animacion.play("idle")
	animacion.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta):
	if not animacion_prioritaria:  # Solo permitir movimiento si no hay animación prioritaria
		if posicion_objetivo != Vector2.ZERO:
			mover_hacia_objetivo(delta)
		else:
			if animacion.animation != "idle":
				animacion.play("idle")

func mover_hacia_objetivo(delta):
	var distancia = posicion_objetivo - global_position
	if distancia.length() > 2:  # Si está lejos del objetivo
		direccion = distancia.normalized()
		velocity = direccion * velocidad
		move_and_slide()

		if not animacion_prioritaria and animacion.animation != "walk":
			animacion.play("walk")

		if direccion.x > 0:
			animacion.flip_h = false  # Mirando a la derecha
		elif direccion.x < 0:
			animacion.flip_h = true   # Mirando a la izquierda
	else:
		posicion_objetivo = Vector2.ZERO
		velocity = Vector2.ZERO
		if not animacion_prioritaria:
			animacion.play("idle")
		emit_signal("llego_al_destino")  # Emitir la señal al llegar al destino

# Método para activar una animación prioritaria desde otra escena
func reproducir_animacion_prioritaria(nombre_animacion: String):
	animacion_prioritaria = true
	animacion.play(nombre_animacion)

# Cuando termina la animación prioritaria
func _on_animation_finished():
	if animacion_prioritaria:
		animacion_prioritaria = false
		emit_signal("animacion_prioritaria_terminada")  # Emitir señal al finalizar la animación
		animacion.play("idle")  # Volver a "idle" después de la animación prioritaria
