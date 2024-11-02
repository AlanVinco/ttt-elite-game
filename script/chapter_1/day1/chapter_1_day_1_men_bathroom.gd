extends Node2D

@onready var player = $player

var scenes = {
	"hallway": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
}
@export var TextScene : PackedScene
@onready var opciones_scene = preload("res://scenes/options_layer.tscn")
var opciones_instance

var dialogs = []
var frame_counter = 0
var acto = 1
var player_start_position = Vector2(587, 127)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#CULTO
	ReputationManager.register_npc("CULTO1")
	ReputationManager.register_npc("CULTO2")
	ReputationManager.register_npc("CULTO3")
	ReputationManager.register_npc("CHORIZU")
	#ReputationManager.modify_reputation("CHORIZU", -10)

	check_culto_reputation()
	$liderC.play("idle")
	####
	scenes["hallway"]["button"] = $salir/Button
	player.limit_left = -30
	player.limit_right = 624
	MusicManager.music_player["parameters/switch_to_clip"] = "BATHROOM THEME"
	
	if GlobalTransition.player_position_men_bahtroom != Vector2():
		player.position = GlobalTransition.player_position_men_bahtroom

	# Conectar señales dinámicamente
	for door_name in scenes.keys():
		var button = scenes[door_name]["button"]
		var door = button.get_parent()

		if door and is_instance_valid(door):
			door.connect("body_entered", Callable(self, "_on_door_body_entered").bind(door_name))
			door.connect("body_exited", Callable(self, "_on_door_body_exited").bind(door_name))
		
		# Conectar la señal "pressed" del botón directamente
		if button and is_instance_valid(button):
			button.connect("pressed", Callable(self, "_on_btn_entrar_pressed").bind(door_name))

func _on_door_body_entered(body: Node2D, door_name: String) -> void:
	if body.is_in_group("player_group") and scenes.has(door_name):
		scenes[door_name]["button"].visible = true

func _on_door_body_exited(body: Node2D, door_name: String) -> void:
	if body.is_in_group("player_group") and scenes.has(door_name):
		scenes[door_name]["button"].visible = false

func _on_btn_entrar_pressed(door_name: String) -> void:
	if scenes.has(door_name):
		GlobalTransition.door_open_sound()
		GlobalTransition.player_position_men_bahtroom = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scenes[door_name]["scene_path"])

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

#SCRIPT
func _on_lider_c_frame_changed() -> void:
	frame_counter += 1
	if frame_counter == 4:
		$lick.play()
	if frame_counter == 13:
		$squirt.play()
		$lick.stop()
	
func _on_lider_c_animation_looped() -> void:
	frame_counter = 0

func _on_pelear_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group") and acto ==1:
		$liderC/pelear/Button.visible = true

func _on_pelear_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		$liderC/pelear/Button.visible = false

func _on_button_pressed() -> void:
	$liderC/pelear/Button.visible = false
	player.move = false
	dialogs = ["¿Pero que putas?", "¿Que hace este fenomeno aqui?", "!Saquenlo!"]
	create_text(dialogs, "CHORIZU", "NORMAL")
func _on_all_texts_displayed():
	match acto:
		1: 
			acto += 1
			await get_tree().create_timer(1.0).timeout
			var dialogs = ["!Si señor!", "Oye tu idiota.", "¿No escuchaste?", 
			"Te dijo que te largaras.", "Te estas metiendo..", 
			"Con el culto de los pervertidos.", "Te largas por las buenas...", 
			"O te sacamos por las malas."]
			create_text(dialogs, "CULTO", "NORMAL")
		2:
			var nombres = ["Pelear", "Huir",]
			mostrar_opciones(nombres, "CULTONORMAL")
		3:
			StartGame.create_game(3, "reputation", "CULTO2", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_men_bathroom.tscn")
		4:
			StartGame.create_game(3, "reputation", "CULTO3", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_men_bathroom.tscn")
		5:
			StartGame.create_game(10, "reputation", "CHORIZU", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_men_bathroom.tscn")
		6:	
			acto += 1
			GlobalTransition.transition()
			await get_tree().create_timer(0.5).timeout
			$chizullorar.visible = true
			$chizullorar.play("llorar")
			$chizullorar/chizu_llorar.play()
			$liderC.visible = false
			$chizu_lamento.stop()
			$squirt.stop()
			$lick.stop()
			$risas.stop()
			$liderC.stop()
			await get_tree().create_timer(5.0).timeout
			dialogs = ["Gra.. Gracias por salvarme...", "N.. No se que hubiera pasado...",
			"Si no hubieras llegado.", "Te... Te debo la vida.", "E... Ellos me secuestraron.",
			"Y.. me hicieron cosas horribles.", "Ese culto, siempre esta buscando...", "Nuevas victimas.",
			"Todas las chicas estamos aterradas.", "De nuevo...", "Gracias.", "Ahora me ire a clase."]
			create_text(dialogs, "CHIZU", "NORMAL")
		7:	
			acto += 1
			var nombres = ["Forzar sexo", "Dejarla ir",]
			mostrar_opciones(nombres, "CHIZUNORMAL")
		9:
			acto += 1
			await get_tree().create_timer(5.0).timeout
			$chizuf1.play("pose1")
			$chizuf1/inside.play()
			$chizuf1/grito.play()
			await get_tree().create_timer(10.0).timeout
			dialogs = ["Por que...", "Me destrozaste...",
			"Eres una bestia...", "!Te odioOOOooooooooooo!"]
			create_text(dialogs, "CHIZU", "NORMAL")
		10:
			
			GlobalTransition.player_position_men_bahtroom = player_start_position
			GlobalTransition.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/miniGame/mini_game_player2.tscn")
			
			
# Función para generar botones en la escena de opciones con nombres personalizados
func mostrar_opciones(nombres_botones: Array, npc):
	opciones_instance = opciones_scene.instantiate()
	add_child(opciones_instance)
	
	# Pasar la lista de nombres de los botones a la escena de opciones
	opciones_instance.generar_botones(nombres_botones, npc)
	
	# Conectar la señal que emitirá la escena Opciones
	opciones_instance.connect("boton_presionado", Callable(self, "_on_boton_presionado"))

# Función que se llama cuando se presiona un botón
func _on_boton_presionado(indice: int):
	match indice:
		0:
			cerrar_opciones()
			if acto ==8:
				acto += 1
				MusicManager.music_player["parameters/switch_to_clip"] = "MISTERY THEME"
				GlobalTransition.transition()
				await get_tree().create_timer(0.5).timeout
				$chizullorar.stop()
				$chizullorar.visible = false
				$chizullorar/chizu_llorar.stop()
				$chizuf1.visible = true
				$chizuf1/ropa.play()
				player.visible = false
				await get_tree().create_timer(3.0).timeout
				dialogs = ["!!Q.. que... que haces!!", "Por.. Por favor no lo hagas.",
				"Soy virgen...", "No. No quiero que mi primera vez sea así.",
				"Quiero hacerlo con alguien que ame...", "Por.. Por favor te lo suplico.",
				"No.. No lo hagas.", "Todos te tratan mal.",
				"Pero se que en el fondo...", "No eres un monstruo.", 
				"!Por favor no me lastimes!"]
				create_text(dialogs, "CHIZU", "NORMAL")
			else:
				GlobalTransition.player_position_men_bahtroom = player.position
				StartGame.create_game(3, "reputation", "CULTO1", "easy", "res://scenes/chapter_1/day1/chapter_1_day_1_men_bathroom.tscn")
		1:
			cerrar_opciones()
			if acto ==8:
				GlobalTransition.transition()
				await get_tree().create_timer(0.5).timeout
				$chizullorar.visible = false
				$chizullorar.stop()
				$chizullorar/chizu_llorar.stop()
				player.move = true
				print("AGREGAR COMANDO PARA NO REPETIR END")
			else:
				GlobalTransition.transition()
				await get_tree().create_timer(0.5).timeout
				get_tree().change_scene_to_file("res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn")
			
# Función para cerrar la escena de opciones
func cerrar_opciones():
	if opciones_instance:
		opciones_instance.cerrar_opciones()  # Llama al método para liberar la escena de opciones
		opciones_instance = null  # Limpiar la referencia después de eliminar la instancia

func check_culto_reputation():
	if ReputationManager.get_reputation("CULTO1") <= 90 and ReputationManager.get_reputation("CULTO2") == 100 and ReputationManager.get_reputation("CULTO3") == 100:
		acto = 3
		player.move = false
		await get_tree().create_timer(2.0).timeout
		dialogs = ["Malditasea.", "Mi turno.", "Este idiota no se saldra con la suya."]
		create_text(dialogs, "CULTO", "NORMAL")
	elif ReputationManager.get_reputation("CULTO1") <= 90 and ReputationManager.get_reputation("CULTO2") <= 90 and ReputationManager.get_reputation("CULTO3") == 100:
		acto = 4
		player.move = false
		await get_tree().create_timer(2.0).timeout
		dialogs = ["No puedo creerlo.", "A un lado.", "Conmigo no va a poder.", "Esto se acaba aqui."]
		create_text(dialogs, "CULTO", "NORMAL")
	elif ReputationManager.get_reputation("CULTO1") <= 90 and ReputationManager.get_reputation("CULTO2") <= 90 and ReputationManager.get_reputation("CULTO3") <= 90 and ReputationManager.get_reputation("CHORIZU") == 100:
		acto = 5
		player.move = false
		await get_tree().create_timer(2.0).timeout
		dialogs = ["Que malditos inutiles son.", "¿Que acaso tengo que hacer todo yo?", 
		"¿No ven que estoy ocupado?", "Comiendome a esta exquisita mujer.", 
		"En fin.", "Vaya vaya.", "Veo que eres fuerte.", "Permiteme presentarme.",
		"Soy Chorizu, lider del grupo C.", "Y del culto de los pervertidos.",
		 "Ahora veras lo que le hago...", "A los que se meten.", "!EN NUESTRO CAMINO!"]
		create_text(dialogs, "CHORIZU", "NORMAL")
	elif ReputationManager.get_reputation("CHORIZU") <= 90:
		acto = 6		
		player.move = false
		await get_tree().create_timer(2.0).timeout
		dialogs = ["Puta madre...", "Esta no sera la ultima vez que nos veamos.", "!Vamonos!"]
		create_text(dialogs, "CHORIZU", "NORMAL")

	#CHEAT

func _on_chizuf_1_animation_finished() -> void:
	$chizuf1.play("pose2")
func _input(event):
	#CHEAT
	if Input.is_action_pressed("win"):
		ReputationManager.modify_reputation("CHORIZU", -10)
		check_culto_reputation()
