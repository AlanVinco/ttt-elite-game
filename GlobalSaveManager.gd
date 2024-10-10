#extends Node
#
## Define las teclas para guardar y cargar el juego
#@export var save_key: String = "ui_save"  # Define en el Input Map como 'ui_save' a la tecla deseada (ej. F5)
#@export var load_key: String = "ui_load"  # Define en el Input Map como 'ui_load' a la tecla deseada (ej. F9)
#
#var save_file_path: String = "user://saves/autosave.save"
#
## Datos del juego (modifica esto según las variables que deseas guardar)
#var game_state: Dictionary = {
	#"player_position": Vector2.ZERO,
	#"score": 0,
#}
#
#func _ready():
	## Asegúrate de que el nodo esté siempre disponible
	#set_process(true)
#
#func _process(delta):
	#if Input.is_action_just_pressed("save"):
		#save_game()
	#elif Input.is_action_just_pressed("load"):
		#load_game()
#
## Función para guardar el juego
#func save_game():
	#var save_data = {
		#"player_position": game_state.player_position,
		#"score": game_state.score,
	#}
	#
	#var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	#if file:
		#file.store_var(save_data)
		#file.close()
		#print("Juego guardado exitosamente en", save_file_path)
#
## Función para cargar el juego
#func load_game():
	#if FileAccess.file_exists(save_file_path):
		#var file = FileAccess.open(save_file_path, FileAccess.READ)
		#if file:
			#var loaded_data = file.get_var()
			#file.close()
#
			## Restaura los datos del juego desde el archivo
			#game_state.player_position = loaded_data["player_position"]
			#game_state.score = loaded_data["score"]
#
			## Busca el nodo del jugador en la escena actual
			#var player_node = find_player_node()
#
			#if player_node:
				## Actualiza la posición del jugador
				#player_node.position = game_state.player_position
				#print("Posición del jugador restaurada.")
			#else:
				#print("El nodo del jugador no fue encontrado.")
	#else:
		#print("Archivo de guardado no encontrado.")
#
## Función para encontrar el nodo del jugador de manera recursiva
#func find_player_node():
	#var root_node = get_tree().current_scene  # Accede a la escena actual
	#return find_node_recursively(root_node, "player")
#
## Función auxiliar para hacer una búsqueda recursiva del nodo
#func find_node_recursively(node: Node, node_name: String) -> Node:
	#if node.name == node_name:
		#return node
	#for child in node.get_children():
		#var result = find_node_recursively(child, node_name)
		#if result:
			#return result
	#return null


# GlobalSaveManager.gd

extends Node

var game_state: Dictionary = {}
var save_file_path: String = "user://saves/autosave.save.dat"
var current_scene_path: String = ""

func save_game():
	if current_scene_path == "":
		print("No hay escena cargada para guardar.")
		return

	game_state["current_scene"] = current_scene_path

	
		# Guarda también la posición del jugador y la puntuación, si existen.
	var player_node = find_player_node()
	if player_node:
		game_state["player_position"] = player_node.position


	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		file.store_var(game_state)
		file.close()
		print("Juego guardado exitosamente en", save_file_path)

func load_game():
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if file:
		game_state = file.get_var()
		file.close()

		if game_state.has("current_scene"):
			print(game_state)
			# Cambiar a la escena guardada usando change_scene_to_file()
			change_scene_to_file(game_state["current_scene"])

		print("Juego cargado exitosamente.")
	else:
		print("No se encontró un archivo de guardado.")

func change_scene_to_file(scene_path: String) -> void:
	# Cambia la escena usando el método change_scene_to_file
	get_tree().change_scene_to_file(scene_path)
	current_scene_path = scene_path


# Función para encontrar el nodo del jugador de manera recursiva
func find_player_node() -> Node:
	var root_node = get_tree().current_scene  # Accede a la escena actual
	if root_node:
		return find_node_recursively(root_node, "player")
	return null

# Función auxiliar para hacer una búsqueda recursiva del nodo
func find_node_recursively(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var result = find_node_recursively(child, node_name)
		if result:
			return result
	return null
