extends Node

var player_position: Vector2 = Vector2()

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
