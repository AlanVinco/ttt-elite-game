extends Node2D

@onready var Irla = $irla_player
@onready var player = $player

@export var next_scene : PackedScene

func _ready() -> void:
	player.limit_left = -232
	player.limit_right = 392
	GlobalTime.irla_bathroom.connect(self._irla_bathroom)
	Irla.connect("llego_al_destino", Callable(self, "_accion_despues_de_llegar"))
	#Breef.connect("animacion_prioritaria_terminada", Callable(self, "_accion_despues_de_animacion"))
	
	MusicManager.music_player["parameters/switch_to_clip"] = "CLASSROOM THEME"
	if MusicManager.music_player.playing == false:
		MusicManager.music_player.play()
		
	await get_tree().create_timer(138).timeout
	$"CLASSROOM THEME".play()

func _irla_bathroom():
	Irla.posicion_objetivo = Vector2(430, 120)
	
func _accion_despues_de_llegar():
	print("ya llego al baño")
	Irla.visible = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	GlobalTransition.transition()
	await await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(next_scene) 
	
