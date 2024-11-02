extends Node

var player_position: Vector2 = Vector2()

var player_position_main_classroom:Vector2 = Vector2()
var player_position_hallway:Vector2 = Vector2()
var player_position_woman_bahtroom:Vector2 = Vector2()
var player_position_patio:Vector2 = Vector2()
var player_position_azotea:Vector2 = Vector2()
var player_position_salida:Vector2 = Vector2()
var player_position_men_bahtroom:Vector2 = Vector2()
var player_position_estatua:Vector2 = Vector2()

func transition():
	$AnimationPlayer.play("TRANSITION")

func door_lock():
	$"Door Lock".play()

func door_open_sound():
	$"Door open".play()

func transition_start():
	$AnimationPlayer.play("TRANSITION_START")

func transition_end():
	$AnimationPlayer.play("END_ACT_TUTORIAL")

func changeModulate(color1, color2, color3, color4):
	var colors = Color(color1, color2, color3, color4)
	$CanvasModulate.set_color(colors)

func elevador_sound():
	$elevador.play()
