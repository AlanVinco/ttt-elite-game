extends Node2D

@onready var playerNpc = $PlayerAnimations
@onready var irlaBath = $"Irla-bath"
@export var TextScene : PackedScene
var back_scene = "res://scenes/chapter_1/day1/chapter_1_day_1_bathroom.tscn"
@export var next_scene : PackedScene

var dialogs = ["¿¿PERO QUE MIERDA HACES AQUI??", "!!LARGATE YAAAA!!"]
var acto = 1

# Referencia a la escena de opciones
@onready var opciones_scene = preload("res://scenes/options_layer.tscn")
var opciones_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ReputationManager.register_npc("IRLA")
	$PlayerAnimations.play("idle")
	await get_tree().create_timer(2.0).timeout
	create_text(dialogs, "IRLA", "NORMAL")
	
	##QUITAR
	ReputationManager.modify_reputation("IRLA", -50)


func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)
	
func _on_all_texts_displayed():
	match acto:
		1:
			acto_1()
		2:
			acto_2()
		3:
			acto_3()
		4:
			acto_4()
		_:
			print("Agregar final")                          

func go_to_next_scene(next_scene):
	GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(next_scene)

func acto_1():
	var dialogs = [".... jeje.", "jeje..", "jejejeje"]
	create_text(dialogs, "PLAYER", "NORMAL")
	acto += 1

func acto_2():
	if ReputationManager.get_reputation("IRLA") < 60:
		await get_tree().create_timer(2.0).timeout
		dialogs = ["Hm...", "...", "!NO TE ACERQUES!"]
		create_text(dialogs, "IRLA", "NORMAL")
		acto+=1
	else:
		go_to_next_scene(back_scene)

func acto_3():
	GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	playerNpc.flip_h = true
	playerNpc.position = Vector2(204, 89)
	await get_tree().create_timer(1.0).timeout
	acto_4()

func acto_4():
	var nombres = ["Blowjob", "Oral", "Sex"]
	mostrar_opciones(nombres, "IRLANORMAL")

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
			print("Se presionó el botón 0: Ejecutando función A")
			ejecutar_funcion_A()
		1:
			print("Se presionó el botón 1: Ejecutando función B")
			ejecutar_funcion_B()
		_:
			print("Se presionó el botón %d" % indice)

# Función para cerrar la escena de opciones
func cerrar_opciones():
	if opciones_instance:
		opciones_instance.cerrar_opciones()  # Llama al método para liberar la escena de opciones
		opciones_instance = null  # Limpiar la referencia después de eliminar la instancia

# Ejemplos de funciones vinculadas a los botones
func ejecutar_funcion_A():
	print("OFunción A ejecutada")
	cerrar_opciones()  # Cerrar opciones después de ejecutar la función A

func ejecutar_funcion_B():
	print("Función B ejecutada")
	cerrar_opciones()  # Cerrar opciones después de ejecutar la función B
