extends Node2D

@onready var player = $player
var scenes = {
	"hallway": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"estatua": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_estatua.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
	"conserjeria": {
		"scene_path": "res://scenes/chapter_1/day1/chaper_1_day_1_conserjeria.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	}
}

func _ready() -> void:
	# Ahora se asignan las referencias a los botones, cuando ya están cargados en la escena
	scenes["hallway"]["button"] = $hallWay_Door/Btn_entrar_pasillo
	scenes["estatua"]["button"] = $estatua_Door/Btn_entrar_estatua
	scenes["conserjeria"]["button"] = $conserjeria_Door/Btn_conserjeria

	player.limit_left = -87
	player.limit_right = 678
	MusicManager.music_player["parameters/switch_to_clip"] = "CLASSROOM THEME"
	MusicManager.music_player.play()

	if GlobalTransition.player_position_patio != Vector2():
		player.position = GlobalTransition.player_position_patio

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
		GlobalTransition.player_position_patio = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scenes[door_name]["scene_path"])
