extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reproduce la animación "draw" solo una vez
	play("draw")

func _on_animation_looped() -> void:
	stop()
	frame = sprite_frames.get_frame_count("draw") - 1
