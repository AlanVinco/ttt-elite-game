extends CharacterBody2D

class_name Player

@export var speed: float = 200.0  # Velocidad de movimiento

@onready var animated_sprite = $AnimatedSprite2D  # Referencia al nodo AnimatedSprite2D

@export var limit_right = 392
@export var limit_left = -850

@export var move = true

func _physics_process(delta: float) -> void:
	$camara.limit_right = limit_right
	$camara.limit_left = limit_left
	# Movimiento horizontal (izquierda/derecha)
	if Input.is_action_pressed("ui_left") and move:
		$PointLight2D.position = Vector2(-19, -43)
		velocity.x = -speed  # Mover a la izquierda
		animated_sprite.play("walk")  # Reproducir animación de caminar
		animated_sprite.flip_h = true  

	elif Input.is_action_pressed("ui_right") and move:
		#print(global_position)
		$PointLight2D.position = Vector2(19, -43)
		velocity.x = speed  # Mover a la derecha
		animated_sprite.play("walk")  # Reproducir animación de caminar
		animated_sprite.flip_h = false
		#if global_position >= Vector2(841.6653, 289):
			#stop_camera()

	else:
		velocity.x = 0  # Detener el movimiento cuando no se presiona ninguna tecla
		animated_sprite.play("idle")  # Reproducir animación de estar quieto

	# Mover el personaje
	velocity.y = 0  # Asegurar que no hay movimiento vertical
	move_and_slide()
	
#func stop_camera():
	#$camara.

#
#func _ready() -> void:
## Restaurar la posición cuando se carga la escena
	#if GlobalTransition.player_position != Vector2():
		#position = GlobalTransition.player_position
