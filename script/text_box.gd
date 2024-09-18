extends MarginContainer

@onready var labelText = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()  # Se emite cuando termina un texto
signal all_texts_displayed()  # Se emite cuando todos los textos terminan

# VARIABLES GLOBALES
@export var typing_speed: float = 0.05  # Velocidad del efecto de tipeo
var is_typing = false
var current_dialog_index = 0

# Función para iniciar el efecto de tipeo en cualquier Label
func start_typing_effect(text_array: Array) -> void:
	var label = $MarginContainer/Label
	if not label or text_array.is_empty():
		#solo checa errores no muestra nada
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
	# Emitir señal cuando termina de escribir un texto
	finished_displaying.emit()

# Función que muestra cada diálogo y espera que el usuario presione Enter
func _show_next_dialog(label: Label, text_array: Array) -> void:
	# Aquí empieza a escribir todos los textos
	while current_dialog_index < text_array.size():
		# Obtener el texto actual
		var full_text = text_array[current_dialog_index]

		# Escribir el diálogo letra por letra
		await _type_text(label, full_text)

		# Esperar a que el jugador presione Enter antes de continuar
		await _wait_for_input("ui_accept")
		current_dialog_index += 1

	# Emitir señal cuando todos los textos han terminado
	#Agregar #if(current_dialog_index >= 1): para emitir al darle enter 
	all_texts_displayed.emit()
	queue_free()

# Función que espera la entrada del usuario para continuar
func _wait_for_input(action: String) -> void:
	# Esperamos hasta que se presione la acción especificada (por ejemplo, "ui_accept")
	while not Input.is_action_just_pressed(action):
		await get_tree().create_timer(0).timeout  # Pausar hasta el siguiente frame para evitar congelamientos

# Función opcional para mostrar el texto directamente si lo necesitas
func display_text(text_to_display):
	text = text_to_display
	$MarginContainer/Label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		$MarginContainer/Label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.x -= size.y / 2
	
	$MarginContainer/Label.text = ""
