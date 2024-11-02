extends Node

var NUMBER_ROUNDS = 0
var GAME_MODE = ""
var CHARACTER = ""
var DIFFICULTY = ""
var NEXT_SCENE = ""
var GAME_SCENE = "res://scenes/game/game.tscn"
var BATTLE_SCENE = "res://scenes/battle/battle_animation.tscn"

# Función para iniciar el juego
func create_game(rounds, gameMode, character, difficulty, nextScene):
	NUMBER_ROUNDS = rounds
	GAME_MODE = gameMode
	CHARACTER = character
	DIFFICULTY = difficulty
	NEXT_SCENE = nextScene

	if NUMBER_ROUNDS > 0 and GAME_MODE != "" and CHARACTER != "" and DIFFICULTY != "" and NEXT_SCENE != "":
		print("Iniciar juego")
		MusicManager.music_player["parameters/switch_to_clip"] = CHARACTER + " BATTLE"
		# Cargar la escena de batalla y cambiar la textura
		await load_battle_scene()
		if CHARACTER == "IRLA":
			change_battle_texture("res://art/irla/face/irla_trainer.png")
		if CHARACTER == "BREEF":
			change_battle_texture("res://art/breef/front/breef_trainer.png")
		if CHARACTER == "JOE":
			change_battle_texture("res://art/joe/Joe_trainer.png")
		if CHARACTER == "BOGA":
			change_battle_texture("res://art/boga/boga_trainer.png")
		if CHARACTER == "CULTO1" or CHARACTER == "CULTO2" or CHARACTER == "CULTO3":
			MusicManager.music_player["parameters/switch_to_clip"] = "CULTO BATTLE"
			change_battle_texture("res://art/chorizu/discipulo/culto_trainer.png")
		if CHARACTER == "CHORIZU":
			change_battle_texture("res://art/chorizu/chorizu_trainer.png")
	else:
		print("No se pudo iniciar el juego")
		print("Game Configuration:\n",
			  "--------------------\n",
			  "Number of Rounds: ", NUMBER_ROUNDS, "\n",
			  "Game Mode: ", GAME_MODE, "\n",
			  "Character: ", CHARACTER, "\n",
			  "Difficulty: ", DIFFICULTY, "\n",
			  "Next Scene: ", NEXT_SCENE, "\n",
			  "--------------------")

# Función para cargar la escena de batalla
func load_battle_scene():
	# Eliminar la escena actual si existe
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()  # Eliminar la escena actual
	
	# Instanciar la escena de batalla
	var battle_scene = load(BATTLE_SCENE).instantiate()
	if battle_scene:
		print("Escena de batalla instanciada correctamente")
		get_tree().root.add_child(battle_scene)  # Agregar la escena instanciada al árbol de nodos
		get_tree().current_scene = battle_scene  # Establecer la escena como la escena actual
		await get_tree().process_frame  # Esperar un frame para asegurarse de que la escena se procese correctamente
	else:
		print("Error al cargar la escena de batalla")

# Función para cambiar la textura del TextureRect en la escena de batalla
func change_battle_texture(texture_path: String):
	var current_scene = get_tree().current_scene  # Obtener la escena actual
	if current_scene == null:
		print("Error: La escena actual es nula.")
		return
	
	var texture_rect = current_scene.get_node("IRLA")  # Ajustar el path según tu estructura de nodos
	if texture_rect and texture_rect is TextureRect:
		var new_texture = load(texture_path)  # Cargar la nueva textura
		texture_rect.texture = new_texture  # Cambiar la textura
		print("Textura cambiada exitosamente")
	else:
		print("No se encontró el TextureRect o no es un TextureRect válido")
