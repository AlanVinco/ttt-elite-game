extends Node

var KEYS = 0

signal BATHROOM_KEY

func get_key():
	KEYS += 1
	
	emit_signal("BATHROOM_KEY")
