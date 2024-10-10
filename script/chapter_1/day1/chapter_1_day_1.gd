extends Node2D

@onready var Irla = $irla_player
@onready var player = $player

@export var next_scene : PackedScene

var can_enter_hallway = false

func _ready() -> void:
	
	if GlobalTime.IRLA_ACTION == "IN CLASS":
		$irla_player.visible = true
	#guardado:
	load_save_data("res://scenes/chapter_1/day1/chapter_1_day_1.tscn")
	#Posicion player
	if GlobalTransition.player_position_main_classroom != Vector2():
		player.position = GlobalTransition.player_position_main_classroom
	
	player.limit_left = -345
	player.limit_right = 654
	GlobalTime.irla_bathroom.connect(self._irla_bathroom)
	Irla.connect("llego_al_destino", Callable(self, "_accion_despues_de_llegar"))
	#Breef.connect("animacion_prioritaria_terminada", Callable(self, "_accion_despues_de_animacion"))
	
	MusicManager.music_player["parameters/switch_to_clip"] = "CLASSROOM THEME"
	if MusicManager.music_player.playing == false:
		MusicManager.music_player.play()
		
	await get_tree().create_timer(138).timeout
	$"CLASSROOM THEME".play()

func _irla_bathroom():
	Irla.posicion_objetivo = Vector2(430, 120)
	
func _accion_despues_de_llegar():
	print("ya llego al baño")
	Irla.visible = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		can_enter_hallway = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		can_enter_hallway = false
	
# Método para establecer los datos cargados
func load_save_data(scene_path):
	GlobalSaveManager.current_scene_path = scene_path
	var data = GlobalSaveManager.game_state
	
	if data.has("player_position"):
		player.position = data["player_position"]

func _input(event):
	if event.is_action_pressed("ui_right") and can_enter_hallway:
		GlobalTransition.door_open_sound()  
		GlobalTransition.player_position_main_classroom = player.position
		GlobalTransition.transition()
		await await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_packed(next_scene) 
