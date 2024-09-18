extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

@export var TextScene : PackedScene


var player: int
var grid_data: Array
var board_size: int
var cell_size: int
var grid_pos: Vector2i
var turn: int = 0
var is_player_turn: bool = true
var game_over: bool = false  # Para verificar si el juego ha terminado

#Actos
var Acto = 0
var next_scene = "res://scenes/prologo/tutorial/tutorial_school_1.tscn"

@onready var camera = $Camera2D
var smoothing_speed: float = 0.1
var disabled_player_move = false

@export var difficulty : String = "hard"

var dialogs = [
	"Por dios apurate.",
	"No tengo todo el dia...",
	"Es tu turno.",
	"¿O nisiquiera eso sabes hacer?"
]

func _ready():
	MusicManager.music_player.play()
	
	$transition.visible = true
	$AnimationPlayer.play("transition")
	await get_tree().create_timer(1.0).timeout
	
	create_text(dialogs)
	#$TextBox.visible = true
	#DialogManager.start_typing_effect(label, dialogs)
	
	await get_tree().create_timer(4.0).timeout
	
	#board_size = 185
	#cell_size = board_size / 3
	#new_game()

func _input(event):
	if is_player_turn and !game_over:  # Permitir input si es el turno del jugador y el juego no ha terminado
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !disabled_player_move:
				# Obtener la posición global del mouse con respecto a la cámara
				var global_mouse_position = camera.get_global_mouse_position()
				
				if global_mouse_position.x < board_size:
					grid_pos = Vector2i(global_mouse_position / cell_size)
					if grid_data[grid_pos.y][grid_pos.x] == 0:
						grid_data[grid_pos.y][grid_pos.x] = player
						create_marker(player, Vector2(grid_pos * cell_size) + Vector2(cell_size / 2, cell_size / 2))
						turn += 1
						check_game_state()
						if !game_over:
							is_player_turn = false
							ai_move()

func new_game():
	player = 1  # Jugador comienza
	turn = 0
	game_over = false
	is_player_turn = true
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, -1]
	]

func create_marker(player, position):
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)

# Verificar el estado del juego
func check_game_state():
	var winner = check_winner()

	if winner == 1:
		print("El jugador ganó")
		game_over = true
	elif winner == -1:
		acto_2()
		print("La IA ganó")
		game_over = true
	elif check_draw():
		print("Empate")
		game_over = true

func check_winner() -> int:
	# Verificar filas
	for i in range(3):
		if grid_data[i][0] == grid_data[i][1] and grid_data[i][1] == grid_data[i][2] and grid_data[i][0] != 0:
			return grid_data[i][0]

	# Verificar columnas
	for i in range(3):
		if grid_data[0][i] == grid_data[1][i] and grid_data[1][i] == grid_data[2][i] and grid_data[0][i] != 0:
			return grid_data[0][i]

	# Verificar diagonales
	if grid_data[0][0] == grid_data[1][1] and grid_data[1][1] == grid_data[2][2] and grid_data[0][0] != 0:
		return grid_data[0][0]
	if grid_data[0][2] == grid_data[1][1] and grid_data[1][1] == grid_data[2][0] and grid_data[0][2] != 0:
		return grid_data[0][2]

	# Si no hay ganador
	return 0

func check_draw() -> bool:
	# Si hay alguna celda vacía, no es empate
	for row in grid_data:
		for cell in row:
			if cell == 0:
				return false
	# Si todas las celdas están llenas y no hay ganador, es empate
	return true

func ai_move():
	# Esperar 1 segundo antes de que la IA realice su movimiento
	await get_tree().create_timer(1.0).timeout

	if game_over:
		return  # No hacer nada si el juego ha terminado

	# Seleccionar la estrategia según la dificultad
	if difficulty == "easy":
		ai_move_easy()
	elif difficulty == "normal":
		ai_move_normal()
	elif difficulty == "hard":
		ai_move_hard()

	# Verificar el estado del juego después del turno de la IA
	check_game_state()

	if !game_over:
		is_player_turn = true  # Volver a habilitar el turno del jugador si el juego no ha terminado

func find_winning_move(player_to_check):
	for y in range(3):
		for x in range(3):
			if grid_data[y][x] == 0:
				grid_data[y][x] = player_to_check
				if check_winner() == player_to_check:
					grid_data[y][x] = 0
					return Vector2(x, y)
				grid_data[y][x] = 0
	return null

func make_move(position):
	grid_data[position.y][position.x] = -1
	create_marker(-1, position * cell_size + Vector2(cell_size / 2, cell_size / 2))
	turn += 1

func make_random_move():
	var empty_cells = []
	for y in range(3):
		for x in range(3):
			if grid_data[y][x] == 0:
				empty_cells.append(Vector2(x, y))
	if empty_cells.size() > 0:
		var random_cell = empty_cells[randi() % empty_cells.size()]
		make_move(random_cell)

func minimax(grid_data, depth, is_maximizing_player):
	var winner = check_winner()

	# Condiciones de victoria
	if winner == -1:
		return 10 - depth  # La IA gana
	elif winner == 1:
		return depth - 10  # El jugador gana
	elif check_draw():
		return 0  # Empate

	if is_maximizing_player:
		var max_eval = -INF
		for y in range(3):
			for x in range(3):
				if grid_data[y][x] == 0:  # Casilla vacía
					grid_data[y][x] = -1  # Hacer el movimiento para la IA
					var eval = minimax(grid_data, depth + 1, false)
					grid_data[y][x] = 0  # Deshacer el movimiento
					max_eval = max(max_eval, eval)
		return max_eval
	else:
		var min_eval = INF
		for y in range(3):
			for x in range(3):
				if grid_data[y][x] == 0:  # Casilla vacía
					grid_data[y][x] = 1  # Hacer el movimiento para el jugador
					var eval = minimax(grid_data, depth + 1, true)
					grid_data[y][x] = 0  # Deshacer el movimiento
					min_eval = min(min_eval, eval)
		return min_eval

func find_best_move():
	var best_value = -INF
	var best_move = null

	for y in range(3):
		for x in range(3):
			if grid_data[y][x] == 0:  # Casilla vacía
				grid_data[y][x] = -1  # Hacer el movimiento para la IA
				var move_value = minimax(grid_data, 0, false)
				grid_data[y][x] = 0  # Deshacer el movimiento

				if move_value > best_value:
					best_move = Vector2(x, y)
					best_value = move_value

	return best_move

func ai_move_easy():
	# Realizar un movimiento aleatorio
	make_random_move()

func ai_move_normal():
	var winning_move = find_winning_move(-1)  # IA busca ganar
	var blocking_move = find_winning_move(1)  # IA bloquea al jugador si es necesario

	if winning_move != null:
		make_move(winning_move)
	elif blocking_move != null:
		make_move(blocking_move)
	else:
		make_random_move()
		
func ai_move_hard():
	var best_move = find_best_move()  # Usar minimax para encontrar el mejor movimiento
	if best_move != null:
		make_move(best_move)

func _process(delta):
	# Obtener la posición global del mouse en el mundo
	var mouse_position = get_viewport().get_mouse_position()
	# Suavizar el movimiento de la cámara hacia el mouse
	#camera.position = lerp(camera.position, mouse_position - Vector2(100, 90), smoothing_speed)
	camera.position = lerp(camera.position, mouse_position - Vector2(0, 0), smoothing_speed)


func _on_disabled_2_mouse_entered() -> void:
	print("entro")
	disabled_player_move = true

func _on_disabled_2_mouse_exited() -> void:
	disabled_player_move = false

func _on_disabled_mouse_entered() -> void:
	disabled_player_move = true

func _on_disabled_mouse_exited() -> void:
	disabled_player_move = false

func _on_disabled_3_mouse_entered() -> void:
	disabled_player_move = true

func _on_disabled_3_mouse_exited() -> void:
	disabled_player_move = false

#text test 

func create_text(texto) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, -30)
	add_child(text_box)
	#
# Conectar las señales
	text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, "", "")

func _on_finished_displaying():
	print("Un texto ha sido terminado.")

func _on_all_texts_displayed():
	print("Todos los textos han sido completados.")
	match Acto:
		0:
			acto_1()
		1:
			end_act_2()
		_:
			print("Agregar final")

func acto_1():
	$AnimationPlayer.play("tutorial_1")
	await get_tree().create_timer(0.5).timeout
	$ColorRect.queue_free()
	board_size = 185
	cell_size = board_size / 3
	new_game()
	Acto += 1

func acto_2():
	await get_tree().create_timer(2.0).timeout
	var dialogs_2 = ["JAJAJAJ","Joder, que malo eres!", "No das ni una!", "Lárgate de mi vista!"]
	create_text(dialogs_2)
	
func end_act_2():
	$transition.visible = true
	#await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("end_act")
	
func _add_a_scene_manually():
	# This is like autoloading the scene, only
	MusicManager.music_player["parameters/switch_to_clip"] = "IRLA MAIN"
	get_tree().change_scene_to_file(next_scene)
