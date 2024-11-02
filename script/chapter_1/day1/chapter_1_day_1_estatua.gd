extends Node2D


@onready var player = $player
var next_scene = "res://scenes/chapter_1/day1/chapter_1_day_1_patio.tscn"
@export var TextScene : PackedScene
var dialogs = []
var acto 
var girl_paths = [
		"res://music/sounds/estatua/gemido1.wav",
		"res://music/sounds/estatua/grito1.wav",
		"res://music/sounds/estatua/grito2.wav",
		"res://music/sounds/estatua/grito3.wav",
		"res://music/sounds/estatua/grito4.wav",
		"res://music/sounds/estatua/grito5.wav",
	]
var girl_paths2 = [
		"res://music/sounds/estatua/quejido2.wav",
		"res://music/sounds/estatua/respiracion1.wav",
		"res://music/sounds/estatua/respiracion2.wav",
		"res://music/sounds/estatua/respiracion3.wav",
		"res://music/sounds/estatua/respiracion4.wav",
		"res://music/sounds/estatua/respiracion5.wav",
		"res://music/sounds/estatua/respiracion6.wav",
		"res://music/sounds/estatua/respiracion7.wav",
		"res://music/sounds/estatua/respiracion8.wav",
	]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.limit_left = -80
	player.limit_right = 557
	MusicManager.music_player["parameters/switch_to_clip"] = "ESTATUA THEME"
	$f1.play("f1")
	$f2.play("f2")
	$f3.play("f3")
	$f4.play("f4")
	if GlobalTransition.player_position_estatua != Vector2():
		player.position = GlobalTransition.player_position_estatua

func _on_hall_way_door_body_entered(body: Node2D) -> void:
	$hallWay_Door/Btn_salir.visible = true

func _on_hall_way_door_body_exited(body: Node2D) -> void:
	$hallWay_Door/Btn_salir.visible = false

func _on_btn_salir_pressed() -> void:
	GlobalTransition.door_open_sound()
	GlobalTransition.player_position_estatua = player.position  
	GlobalTransition.transition()
	await await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(next_scene) 
#script
func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	player.move = true
	match acto:
		5:
			acto += 1
			await get_tree().create_timer(2.0).timeout
			var dialogs = ["¿Que mierda quieres de mi?",
			"!Dejame en paz idiota!"]
			create_text(dialogs, "IRLA", "NORMAL")

func _on_button_talk_pressed() -> void:
	player.move = false
	dialogs = ["¿Que carajos haces aqui?", "Esta zona le pertenece al grupo B.", 
	"Largate antes de que..", "Te reviente a golpes idiota."]
	create_text(dialogs, "BOGA", "NORMAL")

func _on_button_fight_pressed() -> void:
	GlobalTransition.player_position_estatua = player.position

func _on_f_3_animation_looped() -> void:
	$inside1.play()

func _on_f_4_animation_looped() -> void:
	$inside2.play()

func _on_f_1_animation_looped() -> void:
	$inside3.play()

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()

func _on_girl_1_finished() -> void:
	random_music(girl_paths, $girl1)

func _on_girl_2_finished() -> void:
	random_music(girl_paths, $girl2)

func _on_girl_4_finished() -> void:
	random_music(girl_paths2, $girl4)
