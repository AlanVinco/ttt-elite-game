extends Node2D

@onready var player = $player

var next_scene="res://scenes/chapter_1/day1/chapter_1_day_1_pasillo_2.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.limit_left = 120
	player.limit_right = 368
	MusicManager.music_player["parameters/switch_to_clip"] = "DIRECCION THEME"


func _on_salida_door_body_entered(body: Node2D) -> void:
	$salida_Door/Btn_salir.visible = true


func _on_salida_door_body_exited(body: Node2D) -> void:
	$salida_Door/Btn_salir.visible = false


func _on_btn_salir_pressed() -> void:
	GlobalTransition.door_open_sound()  
	GlobalTransition.transition()
	await await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(next_scene) 
