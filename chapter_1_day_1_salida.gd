extends Node2D


@onready var player = $player

var scenes = {
	"escuela": {
		"scene_path": "res://scenes/chapter_1/day1/chapter_1_day_1_hallway.tscn",
		"button": null  # Inicialmente null, se asignará en _ready()
	},
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$police.play("default")
	scenes["escuela"]["button"] = $salidaDoor/Btn_entrada
	player.limit_left = -324
	player.limit_right = 1125
	
	if GlobalTransition.player_position_salida != Vector2():
		player.position = GlobalTransition.player_position_salida

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
		GlobalTransition.player_position_salida = player.position
		GlobalTransition.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scenes[door_name]["scene_path"])
