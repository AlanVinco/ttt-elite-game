extends Node2D

@export var TextScene : PackedScene
var Acto = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtener la reputación actual
	check_reputation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_text(texto) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto)
	
func _on_finished_displaying():
	print("Un texto ha sido terminado.")

func _on_all_texts_displayed():
	print("Todos los textos han sido completados.")
	match Acto:
		0:
			pass
		1:
			pass
		2:
			pass
		_:
			print("Agregar final")

func check_reputation():
	var current_rep = ReputationManager.get_reputation("IRLA")
	if current_rep == 100:
		var dialog = ["Ja, como siempre  te gane..."]
		create_text(dialog)
	else:
		var dialog = ["QUEEEE??", "¿Como pude perder?", "Que quieres que haga..."]
		create_text(dialog)
