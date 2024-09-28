extends Control

# Señal para comunicar con la escena principal
signal boton_presionado(indice: int)

# Función para generar los botones dinámicamente, ahora con nombres personalizados
func generar_botones(nombres_botones: Array, npc):
	var vbox = $CanvasLayer/VBoxContainer

	if npc != "":
		var fullName = "CanvasLayer/"+npc
		var node = get_node_or_null(fullName)
		if node:
			node.visible = true	
	
	# Eliminar todos los hijos del VBoxContainer
	for child in vbox.get_children():
		vbox.remove_child(child)
		child.queue_free()  # Eliminar el nodo correctamente
	
	# Crear botones con los nombres recibidos
	for i in range(nombres_botones.size()):
		var boton = Button.new()
		boton.text = nombres_botones[i]  # Asignar el nombre a cada botón
		boton.name = "boton_%d" % i
		
		# Conectar el botón con la función, pasando el índice
		boton.connect("pressed", Callable(self, "_on_boton_pressed").bind(i))
		vbox.add_child(boton)

# Función que se llama cuando se presiona un botón
func _on_boton_pressed(indice: int):
	emit_signal("boton_presionado", indice) # Emitir señal con el índice del botón presionado

# Función para liberar la escena
func cerrar_opciones():
	queue_free()  # Liberar esta instancia de la memoria
