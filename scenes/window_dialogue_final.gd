extends MarginContainer

@onready var labelText = $CanvasLayer/MarginContainer/Label
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

@onready var audio_player = $AudioStreamPlayer2D  # Asegúrate de tener un nodo AudioStreamPlayer en la escena

#MOSTRAR PJ 

@onready var irla_normal = $"CanvasLayer/irla-normal"
# Función para iniciar el efecto de tipeo en cualquier Label
func start_typing_effect(text_array: Array, character, emotion) -> void:
	
	#REVISAR PJ PARA MOSTRAR
	if character != "":
		var fullName = "CanvasLayer/"+character + emotion
		var node = get_node_or_null(fullName)
		if node:
			node.visible = true
	#END
	
	var label = $CanvasLayer/MarginContainer/Label
	if not label or text_array.is_empty():
		#solo checa errores no muestra nada
		return

	current_dialog_index = 0
	is_typing = false
	# Comenzar a escribir el primer diálogo
	await _show_next_dialog(label, text_array, character)

# Función privada que escribe el texto letra por letra
func _type_text(label: Label, full_text: String, character) -> void:
	var current_text = ""
	var index = 0
	is_typing = true

	while index < full_text.length():
		current_text += full_text[index]
		label.text = current_text

		# Reproducir sonido al escribir cada letra
		_play_letter_sound(character)

		index += 1
		await get_tree().create_timer(typing_speed).timeout  # Pausa entre letras
	
	is_typing = false
	# Emitir señal cuando termina de escribir un texto
	finished_displaying.emit()


# Función que muestra cada diálogo y espera que el usuario presione Enter
func _show_next_dialog(label: Label, text_array: Array, character) -> void:
	# Aquí empieza a escribir todos los textos
	while current_dialog_index < text_array.size():
		# Obtener el texto actual
		var full_text = text_array[current_dialog_index]

		# Escribir el diálogo letra por letra
		await _type_text(label, full_text, character)

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
	$CanvasLayer/MarginContainer/Label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		$CanvasLayer/MarginContainer/Label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.x -= size.y / 2
	
	$CanvasLayer/MarginContainer/Label.text = ""


# Función para reproducir el sonido y cambiar el tono
func _play_letter_sound(character) -> void:
	if audio_player:
		# Cambiar el tono de forma dinámica (ajusta este valor como prefieras)
		#audio_player.pitch_scale = randi_range(80, 120) / 100.0  # Cambia el tono de 0.8 a 1.2
		#audio_player.pitch_scale = 0.1 demond voice
		#audio_player.pitch_scale = 3
		if character == "PLAYER":
			audio_player.pitch_scale = randi_range(80, 120) / 100.0 
		if character == "IRLA" or character == "":
			audio_player.pitch_scale = 3
			#audio_player.pitch_scale = randi_range(300, 500) / 100.0
		if character == "BREEF":
			audio_player.pitch_scale = 0.8
			#audio_player.pitch_scale = randi_range(80, 100) / 100.0
		if character == "DEMON":
			audio_player.pitch_scale = 0.1
			#audio_player.pitch_scale = randi_range(80, 100) / 100.0
		if character == "JOE":
			audio_player.pitch_scale = 0.7
			#audio_player.pitch_scale = randi_range(80, 100) / 100.0
		if character == "TEACHER":
			audio_player.pitch_scale = 2
		if character == "OLVIRA":
			audio_player.pitch_scale = 4
		if character == "ARLETTA":
			audio_player.pitch_scale = 5
		if character == "OTZIRI":
			audio_player.pitch_scale = 6
		if character == "CHIZU":
			audio_player.pitch_scale = 7
		if character == "BOGA":
			audio_player.pitch_scale = 0.5
		if character == "CHORIKURI":
			audio_player.pitch_scale = 1.5
		if character == "CULTO":
			audio_player.pitch_scale = 0.6
		if character == "CHORIZU":
			audio_player.pitch_scale = 0.9
		audio_player.play()
