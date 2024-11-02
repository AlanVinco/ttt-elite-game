extends Node2D

@onready var Irla = $irla_player
@onready var player = $player

var toilet_scene = "res://scenes/chapter_1/bathroom_specials/toilet_irla_scene.tscn"

var hallway_scene = "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn"

@export var TextScene : PackedScene

var dialogs = []
@export var check_irla_action = ""

func _ready() -> void:
	player.limit_left = -30
	player.limit_right = 624
	player.position.x = -10
	MusicManager.music_player["parameters/switch_to_clip"] = "BATHROOM THEME"
	
	#### POSICION PLAYER ###
	if GlobalTransition.player_position_woman_bahtroom != Vector2():
		player.position = GlobalTransition.player_position_woman_bahtroom
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$Area2D/ButtonEspiar.visible = true
		$Area2D/ButtonEntrar.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$Area2D/ButtonEspiar.visible = false
		$Area2D/ButtonEntrar.visible = false


func _on_button_entrar_pressed() -> void:
	next_scene(toilet_scene)

func next_scene(next_scene):
	GlobalTransition.player_position_woman_bahtroom = player.position
	GlobalTransition.door_open_sound()
	GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(next_scene)


func _on_outside_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$Outside/Button.visible = true

func _on_outside_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$Outside/Button.visible = false

func _on_button_pressed() -> void:
		GlobalTransition.door_open_sound()  
		GlobalTransition.player_position_woman_bahtroom = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(hallway_scene)
