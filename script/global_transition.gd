extends Node

func transition():
	print("transicion?")
	$AnimationPlayer.play("TRANSITION")

func door_lock():
	$"Door Lock".play()

func door_open_sound():
	$"Door open".play()
