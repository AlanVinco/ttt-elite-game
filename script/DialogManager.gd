# Dialog.gd (Script Global)
extends Node

@export var typing_speed: float = 0.05  # Velocidad del efecto de tipeo
var is_typing = false
var current_dialog_index = 0

signal finished_displaying()  # Se emite cuando termina un texto
signal all_texts_displayed()  # Se emite cuando todos los textos terminan

# Función para iniciar el efecto de tipeo en cualquier Label
func start_typing_effect(label: Label, text_array: Array) -> void:
	if not label or text_array.is_empty():
		return

	current_dialog_index = 0
	is_typing = false
	
	# Comenzar a escribir el primer diálogo
	await _show_next_dialog(label, text_array)

# Función privada que escribe el texto letra por letra
func _type_text(label: Label, full_text: String) -> void:
	var current_text = ""
	var index = 0
	is_typing = true

	while index < full_text.length():
		current_text += full_text[index]
		label.text = current_text
		index += 1
		await get_tree().create_timer(typing_speed).timeout  # Pausa entre letras
	
	is_typing = false

# Función que muestra cada diálogo y espera que el usuario presione Enter
func _show_next_dialog(label: Label, text_array: Array) -> void:
	while current_dialog_index < text_array.size():
		var full_text = text_array[current_dialog_index]

		# Escribir el diálogo letra por letra
		await _type_text(label, full_text)

		# Esperar a que el jugador presione Enter antes de continuar
		await _wait_for_input("ui_accept")
		current_dialog_index += 1
		
	all_texts_displayed.emit()

# Función que espera la entrada del usuario para continuar
func _wait_for_input(action: String) -> void:
	# Esperamos hasta que se presione la acción especificada (por ejemplo, "ui_accept")
	while not Input.is_action_just_pressed(action):
		await get_tree().create_timer(0).timeout  # Pausar hasta el siguiente frame para evitar congelamientos
