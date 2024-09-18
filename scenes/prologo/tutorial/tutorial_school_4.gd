extends Node2D

@onready var transition = $animationScene
@onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CPUParticles2D.visible = true
	transition.play("trasition_start")
	player.position = Vector2(173, 118)
	print("Escena del demonio")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
