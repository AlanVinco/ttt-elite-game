extends Node2D

var last_key_time = 0.0
var speed_increase = 0.1
var max_speed_scale = 5.0
var min_speed_scale = 1.0
var max_progress = 100.0  # Valor máximo de la ProgressBar
var max_finish = 300.0
var is_key_pressed_recently = false  # Para rastrear si se ha presionado una tecla recientemente
var game_ended = false  # Variable para rastrear si el juego ha terminado

@onready var fatigue_bar = $FatigueBar
@onready var fatigue_timer = $FatigueTimer
@onready var finish_bar = $ProgresBar
@onready var animation = $Animations
@onready var animationLoad = $AnimationsLoad

var animation_position = "scrub"
var frame_counter = 0

func _ready():
	MusicManager.music_player["parameters/switch_to_clip"] = "CLOSER1"
	MusicManager.music_player.play()
	# Configurar la ProgressBar inicialmente
	fatigue_bar.value = 0.0
	fatigue_bar.max_value = max_progress
	finish_bar.value = 0.0
	finish_bar.max_value = max_finish
	animationLoad.visible = true
	animationLoad.play("lick")
	animation.visible = false
	
	# Configurar el Timer
	fatigue_timer.wait_time = 0.5  # Cada 0.5 segundos
	fatigue_timer.connect("timeout", Callable(self, "_on_fatigue_timer_timeout"))
	fatigue_timer.start()

func _input(event):
	if game_ended:  # Ignorar entradas si el juego ha terminado
		return
		
	if event is InputEventKey and event.pressed and not event.is_echo():
		is_key_pressed_recently = true  # Registrar que se ha presionado una tecla recientemente

		var current_time = Time.get_ticks_msec()
		
		# Si esta es la primera vez presionando la tecla, inicializamos last_key_time
		if last_key_time == 0.0:
			last_key_time = current_time

		# Calcular el tiempo desde la última vez que se presionó la tecla
		var time_since_last_key = current_time - last_key_time
		last_key_time = current_time

		# Si presionas la tecla rápidamente (menos de 300 ms), aumentamos la velocidad de la animación
		if time_since_last_key < 300:
			animation.speed_scale = min(animation.speed_scale + speed_increase, max_speed_scale)
			# Aumentar la ProgressBar hasta su valor máximo
			fatigue_bar.value = min(fatigue_bar.value + speed_increase * 10, max_progress)
			finish_bar.value = min(finish_bar.value + 1, max_finish)
		else:
			# Si no se presiona rápido, volvemos a la velocidad normal
			animation.speed_scale = min_speed_scale

		animation.play(animation_position)
		animationLoad.visible = false
		animationLoad.stop()
		animation.visible = true

func _on_fatigue_timer_timeout():
	if game_ended:  # Detener lógica si el juego ha terminado
		return
	
	# Reducir la fatiga y finish solo si no se ha presionado una tecla recientemente
	if not is_key_pressed_recently:
		animationLoad.play("lick")
		animationLoad.visible = true
		animation.visible = false
		animation.stop()
		if fatigue_bar.value > 0:
			fatigue_bar.value = max(fatigue_bar.value - 2, 0)
		if finish_bar.value > 0:
			finish_bar.value = max(finish_bar.value - 1, 0)
	else:
		# Reiniciar el estado después de que se haya evaluado
		is_key_pressed_recently = false

func _on_progres_bar_value_changed(value: float) -> void:
	if finish_bar.value >= max_finish/3 and finish_bar.value <= max_finish/1.5:
		animation_position = "blow_job"
		var current_clip = MusicManager.music_player["parameters/switch_to_clip"]
		if current_clip != "CLOSER2":
			MusicManager.music_player["parameters/switch_to_clip"] = "CLOSER2"
	if finish_bar.value <= max_finish/3:
		animation_position = "scrub"
		var current_clip = MusicManager.music_player["parameters/switch_to_clip"]
		if current_clip != "CLOSER1":
			MusicManager.music_player["parameters/switch_to_clip"] = "CLOSER1"
		
	if finish_bar.value == max_finish/1.5:
		animation_position = "blow_extreme"
		MusicManager.music_player["parameters/switch_to_clip"] = "CLOSER3"
		var current_clip = MusicManager.music_player["parameters/switch_to_clip"]
		if current_clip != "CLOSER3":
			MusicManager.music_player["parameters/switch_to_clip"] = "CLOSER3"
			
			
	if finish_bar.value == max_finish:
		end_game("win")

#TEST
#func _on_fatigue_bar_value_changed(value: float) -> void:
	#if fatigue_bar.value == max_progress:
		#end_game("lose")

func end_game(value) -> void:
	# Detener la lógica del juego
	game_ended = true
	fatigue_timer.stop()  # Detener el temporizador
	
	# Detener cualquier animación o mostrar una pantalla final
	animation.stop()
	animationLoad.stop() 
	
	# Opcionalmente puedes mostrar un mensaje o cambiar de escena
	GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	animation.visible = false
	animationLoad.visible = false
	MusicManager.music_player["parameters/switch_to_clip"] = "CLOSERFINAL"
	
	if value == "lose":
		$cumFail.visible = true
		$cumFail.play("cumfail")
		$irlaSounds.stream = load("res://music/sounds/blow/blow2/llorar1.wav")
		$irlaSounds.play()
	else:
		$cumWin.visible = true
		$cumWin.play("cumfinal")

func _on_cum_fail_animation_finished() -> void:
	$Reload.visible = true
	$Terminar.visible = true
	$irla_fail_finish.play()

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()

func _on_animations_frame_changed() -> void:
	# Array con las rutas de los sonidos
	var music_paths = [
		"res://music/sounds/blow/inside1.wav",
		"res://music/sounds/blow/inside2.wav",
		"res://music/sounds/blow/inside3.wav"
	]
	var music_inside2 = [
		"res://music/sounds/minigame2/inside1.mp3",
		"res://music/sounds/minigame2/inside2.mp3",
		"res://music/sounds/minigame2/inside3.mp3",
		"res://music/sounds/minigame2/inside4.mp3",
		"res://music/sounds/minigame2/inside5.mp3",
		"res://music/sounds/minigame2/inside6.mp3",
		"res://music/sounds/minigame2/inside7.mp3",
		"res://music/sounds/minigame2/inside8.mp3",
		"res://music/sounds/minigame2/inside9.mp3",
	]
	var irla_blow_paths = [
		"res://music/sounds/minigame2/gemido1.wav",
		"res://music/sounds/minigame2/gemido2.wav",
		"res://music/sounds/minigame2/gemido3.wav",
		"res://music/sounds/minigame2/gemido4.wav",
		"res://music/sounds/minigame2/gemido5.wav",
		"res://music/sounds/minigame2/gemido6.wav",
		"res://music/sounds/minigame2/gemido7.wav",
		"res://music/sounds/minigame2/gemido8.wav",
		"res://music/sounds/minigame2/gemido9.wav",
		"res://music/sounds/minigame2/gemido10.wav",
		"res://music/sounds/minigame2/gemido11.wav",
		"res://music/sounds/minigame2/gemido12.wav",
		"res://music/sounds/minigame2/gemido13.wav",
		"res://music/sounds/minigame2/gemido14.wav",
		"res://music/sounds/minigame2/gemido15.wav",
		"res://music/sounds/minigame2/gemido16.wav",
		"res://music/sounds/minigame2/gemido_grito1.wav",
		"res://music/sounds/minigame2/gemido_grito2.wav"
	]
	
	
	if animation.animation != "scrub":
		if animation.frame == 3:
			random_music(music_inside2, $slime)
			random_music(irla_blow_paths, $irlaSounds)
	else:
		if animation.frame == 1:
			random_music(music_paths, $slime)
			random_music(irla_blow_paths, $irlaSounds)

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()

func _on_cum_win_frame_changed() -> void:
	# Array con las rutas de los sonidos
	var music_paths = [
		"res://music/sounds/blow/cum1.wav",
		"res://music/sounds/blow/cum2.wav",
		"res://music/sounds/blow/cum4.wav"
	]
	var irla_blow_paths = [
		"res://music/sounds/blow/enlaboca1.wav",
		"res://music/sounds/blow/enlaboca2.wav",
		"res://music/sounds/blow/enlaboca3.wav",
		"res://music/sounds/blow/spermboca4.wav",
		"res://music/sounds/blow/spermboca5.wav",
		"res://music/sounds/blow/spermboca6.wav",
		"res://music/sounds/blow/spermboca7.wav",
	]

	if $cumWin.frame == 2:
		$slime.stream = load(music_paths[2])
		$irlaSounds.stream = load(irla_blow_paths[1])
		$slime.play()
		$irlaSounds.play()
	if $cumWin.frame == 5:
		$slime.stream = load(music_paths[0])
		$irlaSounds.stream = load(irla_blow_paths[0])
		$slime.play()
		$irlaSounds.play()
	if $cumWin.frame == 9:
		$slime.stream = load(music_paths[1])
		$irlaSounds.stream = load(irla_blow_paths[1])
		$slime.play()
		$irlaSounds.play()
	if $cumWin.frame == 15:
		$slime.stream = load(music_paths[1])
		$irlaSounds.stream = load(irla_blow_paths[2])
		$slime.play()
		$irlaSounds.play()

func _on_cum_win_animation_finished() -> void:
	$irla_finish.play()
	$Reload.visible = true
	$Siguiente.visible = true

func _on_animations_load_frame_changed() -> void:
	frame_counter += 1
	var music_paths = [
		"res://music/sounds/blow/blow2/lamer1.wav",
		"res://music/sounds/blow/blow2/lamer2.wav",
		"res://music/sounds/blow/blow2/lamer3.wav",
		"res://music/sounds/blow/blow2/lamer4.wav",
		"res://music/sounds/blow/blow2/lamer5.wav",
	]
	# Cada 2 cuadros, ejecutar la función
	if frame_counter >= 3:
		random_music(music_paths, $slime)
		frame_counter = 0  # Reiniciar el contador

func _on_cum_fail_frame_changed() -> void:
	# Array con las rutas de los sonidos
	var music_paths = [
		"res://music/sounds/blow/cum1.wav",
		"res://music/sounds/blow/cum2.wav",
	]

	if $cumFail.frame == 6:
		$slime.stream = load(music_paths[1])
		$slime.play()
	if $cumFail.frame == 11:
		$slime.stream = load(music_paths[1])
		$slime.play()

func _on_siguiente_pressed() -> void:
	GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/chapter_1/day1/chapter_1_day_1_men_bathroom.tscn")
