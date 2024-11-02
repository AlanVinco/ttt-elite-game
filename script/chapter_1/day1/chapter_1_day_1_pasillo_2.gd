extends Node2D

@onready var player = $player

var scenes = {
	"direccion": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_direction.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"bajar": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"subir": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_azotea.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
}

func _ready() -> void:
	
	# Ahora se asignan las referencias a los botones, cuando ya están cargados en la escena
	scenes["direccion"]["button"] = $DireccionDoor/Btn_direccion
	scenes["bajar"]["button"] = $elevadorDoor/Btn_elevador_bajar
	scenes["subir"]["button"] = $elevadorDoor2/Btn_elevador_subir

	player.limit_left = -730
	player.limit_right = 750
	MusicManager.music_player["parameters/switch_to_clip"] = "CLASSROOM THEME"
	MusicManager.music_player.play()

	if GlobalTransition.player_position_hallway != Vector2():
		player.position = GlobalTransition.player_position_hallway

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
		if door_name == "bajar" or door_name == "subir":
			GlobalTransition.elevador_sound()
		else:
			GlobalTransition.door_open_sound()
		GlobalTransition.player_position_hallway = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scenes[door_name]["scene_path"])
