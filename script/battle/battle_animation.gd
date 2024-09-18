extends CanvasLayer

@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
#Terminar de arreglar la animacion
func _ready() -> void:
	animation.play("battle_animation")
	$TextureRect/rival_ui.play("animation")
	$TextureRect2/Player_ui_sprites.play("player_ui")

func _animation_end():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
