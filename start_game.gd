extends Node

var NUMBER_ROUNDS = 0
var GAME_MODE = ""
var CHARACTER = ""
var DIFFICULTY = ""
var NEXT_SCENE = ""
var GAME_SCENE = "res://scenes/game/game.tscn"

func create_game(rounds, gameMode, character, difficulty, nextScene):
	
	NUMBER_ROUNDS = rounds
	GAME_MODE = gameMode
	CHARACTER = character
	DIFFICULTY = difficulty
	NEXT_SCENE = nextScene
	
	if NUMBER_ROUNDS > 0 and GAME_MODE != "" and CHARACTER != "" and DIFFICULTY != "" and NEXT_SCENE != "":
		print("Iiniciar juego")
		MusicManager.music_player["parameters/switch_to_clip"] = CHARACTER + " BATTLE"

		get_tree().change_scene_to_file(GAME_SCENE)
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
