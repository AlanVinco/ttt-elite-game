extends CharacterBody2D

signal llego_al_destino
signal animacion_prioritaria_terminada  # Nueva señal

@export var velocidad: float = 200.0
var direccion: Vector2 = Vector2.ZERO
var posicion_objetivo: Vector2 = Vector2.ZERO
var animacion_prioritaria = false  # Para bloquear otras animaciones durante la prioritaria
@onready var animacion = $AnimatedSprite2D

#OPCIONES:
@onready var buttonOptions = $ButtonOptions
@onready var panelOptions = $PanelOptions
@onready var panelFight = $PanelFight
@onready var panelRounds = $PanelRounds

func _ready():
	animacion.play("idle")
	animacion.connect("animation_finished", Callable(self, "_on_animation_finished"))
	#Reputacion
	ReputationManager.register_npc(character)
	var current_rep = ReputationManager.get_reputation(character)
	$Label.text = "Reputacion: " + str(current_rep)
	#Label.text = "Reputación: " + String(current_rep)


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

#Panel de Opciones
@export var gameMode = ""
@export var numberRounds = 0
@export var character = ""
@export var difficulty = ""
@export var nextScene = "res://scenes/chapter_1/day1/chapter_1_day_1.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		buttonOptions.visible = true


func _on_button_options_pressed() -> void:
	buttonOptions.visible = false
	panelOptions.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		buttonOptions.visible = false
		panelOptions.visible = false
		panelFight.visible = false
		panelRounds.visible = false
		gameMode = ""
		numberRounds = 0

#PANEL OPTIONS:
func _on_button_fight_pressed() -> void:
	panelFight.visible = true
	panelOptions.visible = false

#PANEL FIGHT:
func _on_button_back_pressed() -> void:
	panelFight.visible = false
	panelOptions.visible = true

func _on_button_reputation_pressed() -> void:
	#Agregar variable Reputacion
	gameMode = "reputation"
	panelRounds.visible = true
	panelFight.visible = false
	
func _on_button_money_pressed() -> void:
	gameMode = "money"
	numberRounds = 5
	StartGame.create_game(numberRounds, gameMode, character, difficulty, nextScene)
	
#PANEL ROUNDS:
func _on_button_back_2_pressed() -> void:
	panelRounds.visible = false
	panelFight.visible = true


func _on_button_vs_3_pressed() -> void:
	numberRounds = 3
	StartGame.create_game(numberRounds, gameMode, character, difficulty, nextScene)

func _on_button_vs_5_pressed() -> void:
	numberRounds = 5
	StartGame.create_game(numberRounds, gameMode, character, difficulty, nextScene)

func _on_button_vs_10_pressed() -> void:
	numberRounds = 10
	StartGame.create_game(numberRounds, gameMode, character, difficulty, nextScene)
