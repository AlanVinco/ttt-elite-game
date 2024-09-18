# OtroNodo.gd
extends Node2D

@onready var label = $TextBox/MarginContainer/Label  # El Label donde se mostrará el texto

# Array de diálogos que quieres mostrar
var dialogs = [
	"Este es el primer diálogo.",
	"Se escribe letra por letra.",
	"Presiona Enter para avanzar."
]

func _ready():
	# Llamamos a la función del script global para iniciar el diálogo
	DialogManager.start_typing_effect(label, dialogs)
