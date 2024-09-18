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
var next_scene = StartGame.NEXT_SCENE

@onready var camera = $Camera2D
var smoothing_speed: float = 0.1
var disabled_player_move = false

@export var difficulty : String = StartGame.DIFFICULTY

#AGREGAR RONDAS
@export var total_rondas: int = StartGame.NUMBER_ROUNDS  # Número total de rondas
var ronda_actual: int = 1  # Ronda en la que estamos jugando
var puntuacion_jugador: int = 0  # Rondas ganadas por el jugador
var puntuacion_ia: int = 0  # Rondas ganadas por la IA

#BORAR MARCADORES:
var markers = []  # Almacena las instancias de los círculos y equis

#GLOBAL
var character_name = StartGame.CHARACTER
var game_mode = StartGame.GAME_MODE

func _ready():
		#SONGS
		
		#CAMBIAR IMG:
	$Label.text = "Game Configuration:\n" + "--------------------\n" + "Number of Rounds: " + str(total_rondas) + "\n" + "Game Mode: " + game_mode + "\n" + "Character: " + character_name + "\n" + "Difficulty: " + difficulty + "\n" + "--------------------"

	if character_name == "IRLA":
		#$IRLABATTLE.playing = true
		$irla.visible = true
	if character_name == "BREEF":
		#$BREEFBATTLE.playing = true
		$breef.visible = true
		
	if character_name == "JOE":
		#$BREEFBATTLE.playing = true
		$joe.visible = true
		
		
	$transition.visible = true
	$AnimationPlayer.play("transition")
	await get_tree().create_timer(1.0).timeout
	
	#create_text(dialogs)
	#$TextBox.visible = true
	#DialogManager.start_typing_effect(label, dialogs)
	board_size = 185
	cell_size = board_size / 3
	new_game()


func _input(event):
	#CHEAT
	if Input.is_action_pressed("win"):
		if game_mode == "reputation":
			ReputationManager.modify_reputation(character_name, -10)  # Gana 10 de reputación
		else:
			GlobalMoney.win_money()
		print("CHEAT WIN")	
		GlobalTime.change_time()
		_add_a_scene_manually()
	if Input.is_action_pressed("draw"):
		print("CHEAT draw")
		GlobalTime.change_time()
		_add_a_scene_manually()
	if Input.is_action_pressed("lose"):
		if game_mode == "reputation":
			ReputationManager.modify_reputation(character_name, 10)
		else:
			GlobalMoney.lose_money()
		print("CHEAT lose")
		GlobalTime.change_time()
		_add_a_scene_manually()
	#END
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
	clear_markers()  # Eliminar los marcadores de la ronda anterior
	player = 1  # El jugador comienza
	turn = 0
	game_over = false
	is_player_turn = true
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
	print("Ronda: ", ronda_actual, "/", total_rondas)

func create_marker(player, position):
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		markers.append(circle)  # Agregar círculo a la lista de marcadores
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		markers.append(cross)  # Agregar equis a la lista de marcadores

# Verificar el estado del juego
func check_game_state():
	var winner = check_winner()

	if winner == 1:
		print("El jugador ganó la ronda")
		puntuacion_jugador += 1
		game_over = true
		draw_winning_line_for_winner()  # Dibuja la línea si hay ganador
	elif winner == -1:
		print("La IA ganó la ronda")
		puntuacion_ia += 1
		game_over = true
		draw_winning_line_for_winner()  # Dibuja la línea si hay ganador
	elif check_draw():
		print("Empate en la ronda")
		game_over = true
	
	if game_over:
		terminar_ronda()


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

#Rondas
func terminar_ronda():
	# Si algún jugador ha ganado la mitad de las rondas + 1, termina el juego
	if puntuacion_jugador > total_rondas / 2 or puntuacion_ia > total_rondas / 2:
		finalizar_juego()
	elif ronda_actual < total_rondas:
		ronda_actual += 1
		new_game()  # Iniciar la siguiente ronda
	else:
		finalizar_juego()  # Terminar el juego después de todas las rondas

func finalizar_juego():
	if puntuacion_jugador > puntuacion_ia:
		if game_mode == "reputation":
			ReputationManager.modify_reputation(character_name, -10)  # Gana 10 de reputación
			print("El jugador ganó el juego con: ", puntuacion_jugador, "rondas ganadas")
		else:
			GlobalMoney.win_money()
		
	elif puntuacion_ia > puntuacion_jugador:
		if game_mode == "reputation":
			ReputationManager.modify_reputation(character_name, 10)  # Gana 10 de reputación
			print("La IA ganó el juego con: ", puntuacion_ia, "rondas ganadas")
		else:
			GlobalMoney.lose_money()
	else:
		print("El juego terminó en empate")
	# Aquí puedes añadir la lógica para reiniciar o cambiar de escena
	GlobalTime.change_time()
	print("Cambiar a la siguiente escena")
	_add_a_scene_manually()

func _process(delta):
	# Obtener la posición global del mouse en el mundo
	var mouse_position = get_viewport().get_mouse_position()
	# Suavizar el movimiento de la cámara hacia el mouse
	#camera.position = lerp(camera.position, mouse_position - Vector2(100, 90), smoothing_speed)
	camera.position = lerp(camera.position, mouse_position - Vector2(0, 0), smoothing_speed)

func _add_a_scene_manually():
	# This is like autoloading the scene, only
	GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout  
	get_tree().change_scene_to_file(next_scene)
#Borrar marcadores:
func clear_markers():
	for marker in markers:
		marker.queue_free()  # Elimina la instancia del árbol
	markers.clear()  # Vacía la lista
	
# Nueva función para dibujar una línea ganadora
func draw_winning_line(start_pos: Vector2, end_pos: Vector2):
	var line = Line2D.new()
	line.default_color = Color(1, 0, 0)  # Color rojo para la línea
	line.width = 5  # Grosor de la línea
	line.add_point(start_pos)
	line.add_point(end_pos)
	add_child(line)

	# Esperar 3 segundos antes de iniciar la siguiente ronda
	await get_tree().create_timer(0.8).timeout
	line.queue_free()  # Eliminar la línea después de la pausa
	new_game()  # Iniciar la siguiente ronda

func draw_winning_line_for_winner():
	# Verificar filas
	for i in range(3):
		if grid_data[i][0] == grid_data[i][1] and grid_data[i][1] == grid_data[i][2] and grid_data[i][0] != 0:
			var start_pos = Vector2(0, i * cell_size + cell_size / 2)
			var end_pos = Vector2(board_size, i * cell_size + cell_size / 2)
			draw_winning_line(start_pos, end_pos)
			return

	# Verificar columnas
	for i in range(3):
		if grid_data[0][i] == grid_data[1][i] and grid_data[1][i] == grid_data[2][i] and grid_data[0][i] != 0:
			var start_pos = Vector2(i * cell_size + cell_size / 2, 0)
			var end_pos = Vector2(i * cell_size + cell_size / 2, board_size)
			draw_winning_line(start_pos, end_pos)
			return

	# Verificar diagonal principal
	if grid_data[0][0] == grid_data[1][1] and grid_data[1][1] == grid_data[2][2] and grid_data[0][0] != 0:
		var start_pos = Vector2(0, 0)
		var end_pos = Vector2(board_size, board_size)
		draw_winning_line(start_pos, end_pos)
		return

	# Verificar diagonal inversa
	if grid_data[0][2] == grid_data[1][1] and grid_data[1][1] == grid_data[2][0] and grid_data[0][2] != 0:
		var start_pos = Vector2(board_size, 0)
		var end_pos = Vector2(0, board_size)
		draw_winning_line(start_pos, end_pos)
		return
