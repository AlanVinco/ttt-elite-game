extends Node2D

@onready var Irla = $irla_player
@onready var player = $player

@export var next_scene : PackedScene

@export var TextScene : PackedScene

var dialogs = []
@export var check_irla_action = ""

func _ready() -> void:
	player.limit_left = -30
	player.limit_right = 624
	player.position.x = -10
	MusicManager.music_player["parameters/switch_to_clip"] = "CLASSROOM THEME"
	MusicManager.music_player.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$Area2D/ButtonEspiar.visible = true
		$Area2D/ButtonEntrar.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$Area2D/ButtonEspiar.visible = false
		$Area2D/ButtonEntrar.visible = false
