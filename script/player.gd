extends CharacterBody2D

class_name Player

@export var speed: float = 200.0  # Velocidad de movimiento

@onready var animated_sprite = $AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D
@onready var camera = $camara  # Referencia a la cámara

@export var limit_right = 392
@export var limit_left = -850
@export var move = true

var shake_timer = 0.0  # Tiempo restante de shake
var shake_intensity = 5.0  # Intensidad del shake

func _physics_process(delta: float) -> void:
	$camara.limit_right = limit_right
	$camara.limit_left = limit_left
	
	# Movimiento horizontal (izquierda/derecha)
	if Input.is_action_pressed("ui_left") and move:
		if position.x > limit_left:  # Solo mover si no ha superado el límite izquierdo
			$PointLight2D.position = Vector2(-19, -43)
			velocity.x = -speed  # Mover a la izquierda
			animated_sprite.play("walk")  # Reproducir animación de caminar
			animated_sprite.flip_h = true
		else:
			velocity.x = 0  # Detener si alcanza el límite izquierdo

	elif Input.is_action_pressed("ui_right") and move:
		if position.x < limit_right:  # Solo mover si no ha superado el límite derecho
			$PointLight2D.position = Vector2(19, -43)
			velocity.x = speed  # Mover a la derecha
			animated_sprite.play("walk")  # Reproducir animación de caminar
			animated_sprite.flip_h = false
		else:
			velocity.x = 0  # Detener si alcanza el límite derecho

	else:
		velocity.x = 0  # Detener el movimiento cuando no se presiona ninguna tecla
		animated_sprite.play("idle")  # Reproducir animación de estar quieto

	# Mover el personaje
	velocity.y = 0  # Asegurar que no hay movimiento vertical
	move_and_slide()

	# Si hay un shake activo, aplicarlo
	if shake_timer > 0:
		shake_timer -= delta  # Reducir el tiempo de shake
		camera.offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		camera.offset = Vector2(0, 0)  # Restaurar la cámara a su posición original

# Función para iniciar el shake de cámara
func start_camera_shake(duration: float, intensity: float = 5.0) -> void:
	shake_timer = duration  # Establecer el tiempo de duración del shake
	shake_intensity = intensity  # Establecer la intensidad del shake

#
#func _process(delta):
	#GlobalSaveManager.game_state.player_position = position

func _input(event):
	# Comprobar si se presiona una tecla
	if event.is_action_pressed("save"):  # Por defecto, es la tecla "S"
		GlobalSaveManager.save_game()

	if event.is_action_pressed("load"):  # Por defecto, es la tecla "L"
		GlobalSaveManager.load_game()
