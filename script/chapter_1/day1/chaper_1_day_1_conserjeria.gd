extends Node2D

@onready var player = $player

var next_scene = "res://scenes/chapter_1/day1/chapter_1_day_1_patio.tscn"
# Called when the node enters the scene tree for the first time.
var dialogs = []
@export var TextScene : PackedScene
var acto

func _ready() -> void:
	$computer.play("idle")
	player.limit_left = 120
	player.limit_right = 397
	MusicManager.music_player["parameters/switch_to_clip"] = "CONSERJERIA THEME"
# Ajusta un temporizador a la duración de la canción (en segundos)
	var song_length = 168
	var timer = Timer.new()
	timer.wait_time = song_length
	timer.one_shot = false  # Se repetirá automáticamente
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))  # Usa Callable.new para conectar correctamente
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	MusicManager.music_player["parameters/switch_to_clip"] = "CONSERJERIA THEME"

func _on_hall_way_door_body_entered(body: Node2D) -> void:
	$hallWay_Door/Btn_salir.visible = true

func _on_hall_way_door_body_exited(body: Node2D) -> void:
	$hallWay_Door/Btn_salir.visible = false

func _on_btn_salir_pressed() -> void:
	GlobalTransition.door_open_sound()  
	GlobalTransition.transition()
	await await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(next_scene) 

#SCRIPT
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$conserje2/Button.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$conserje2/Button.visible = false

func _on_button_pressed() -> void:
	$conserje2/Button.visible = false
	player.move = false
	var dialogs = ["Oh, pense que eras una jovencita.", "Te dire un secreto.", "Si logras traer una mujer aqui.", "Te dare un objeto muy especial.", "Jejeje"]
	create_text(dialogs, "CHORIKURI", "NORMAL")

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	player.move = true
