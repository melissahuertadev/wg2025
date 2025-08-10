extends Node2D

var ultimo_emisor = null # "match" o "player"
var isWaitingReply: bool = false
var msg_recieved_1_dict: Dictionary
var msg_recieved_2_dict: Dictionary
var msg_sent_1_dict: Dictionary

var msg_r_1 = "¡Hola! ¿Qué tal? Vi en tu perfil que te gusta PLAYER_INTEREST"
var msg_r_2 = ""

func _ready():
	load_dictionaries()
	set_labels_text()


func replace_message(original_str, old_text, new_text):
	var new_str = original_str.replace(old_text, new_text)
	return new_str

func load_dictionaries():
	# Primer mensaje del hombre
	msg_recieved_1_dict = {
		GlobalManager.INTERESES.DEPORTES: "hacer deporte.",
		GlobalManager.INTERESES.CINE: "ir al cine.", 
		GlobalManager.INTERESES.VIDEOJUEGOS: "los videojuegos.", 
		GlobalManager.INTERESES.ANIMES: "ver animes.",
		GlobalManager.INTERESES.LIBROS: "la lectura.",
		GlobalManager.INTERESES.COCINA: "cocinar. Niam",
		GlobalManager.INTERESES.FESTIVALES: "ir a festivales.",
		GlobalManager.INTERESES.MUSICA: "escuchar música",
		GlobalManager.INTERESES.TECH: "la tecnología"
	}
	
	# Segundo mensaje del hombre
	msg_recieved_2_dict = {
		GlobalManager.INTERESES.DEPORTES: "¿Quieres ir a correr juntos este finde?",
		GlobalManager.INTERESES.CINE: "¿Te apetece ir al cine esta noche?",
		GlobalManager.INTERESES.VIDEOJUEGOS: "¿Jugamos algo juntos mañana? 😉😉",
		GlobalManager.INTERESES.ANIMES: "¿Vemos anime en mi casa este sábado?",
		GlobalManager.INTERESES.LIBROS: "¿Vamos a una feria de libros este domingo?",
		GlobalManager.INTERESES.COCINA: "¿Cocinamos algo juntos esta noche?",
		GlobalManager.INTERESES.FESTIVALES: "¿Vienes a un festival conmigo este finde?",
		GlobalManager.INTERESES.MUSICA: "¿Vamos a un concierto este viernes?",
		GlobalManager.INTERESES.TECH: "¿Visitamos una expo de tecnología mañana?"
	}

	# Respuestas de la chica (player)
	msg_sent_1_dict = {
		GlobalManager.INTERESES.DEPORTES: [
			"¡Claro! Vamos a correr.",
			"No, me lesioné. Chau."
		],
		GlobalManager.INTERESES.CINE: [
			"Sí, me encantaría ir.",
			"No, ya vi esa. Chau."
		],
		GlobalManager.INTERESES.VIDEOJUEGOS: [
			"¡De una! Me apunto.",
			"No, no juego. Chau."
		],
		GlobalManager.INTERESES.ANIMES: [
			"Sí, suena genial.",
			"No veo anime. Chau."
		],
		GlobalManager.INTERESES.LIBROS: [
			"Perfecto, vamos.",
			"No leo mucho. Chau."
		],
		GlobalManager.INTERESES.COCINA: [
			"¡Qué rico! Sí.",
			"Odio cocinar. Chau."
		],
		GlobalManager.INTERESES.FESTIVALES: [
			"Obvio, vamos.",
			"No me gustan. Chau."
		],
		GlobalManager.INTERESES.MUSICA: [
			"Sí, me encanta.",
			"Odio ese género. Chau."
		],
		GlobalManager.INTERESES.TECH: [
			"¡Vamos juntos!",
			"No me interesa. Chau."
		]
	}

func _on_animation_finished(anim_name: String):
	if anim_name == "match_chat_animation":
		isWaitingReply = true
		show_player_reply_options()

func get_rand_item_enum():
	#var rand_idx = randi() % GlobalManager.main_character_intereses.size()
	#var rand_item_str = GlobalManager.main_character_intereses[rand_idx]
	var rand_item_str = "DEPORTES" # PARA TESTEAR
	var rand_item_enum = GlobalManager.INTERESES[rand_item_str]
	
	return rand_item_enum

func set_labels_text():
	var rand_item_enum = get_rand_item_enum()
	
	set_msgs_recieved_text(rand_item_enum)
	set_rptas_text(rand_item_enum)

func set_msgs_recieved_text(item_enum):
	var new_message_1 = replace_message(msg_r_1, "PLAYER_INTEREST", msg_recieved_1_dict[item_enum])
	var new_msg_r_2 = msg_recieved_2_dict[item_enum]
	

	mostrar_mensaje_match(new_message_1)


func set_rptas_text(item_enum):
	var RptaPositivaLabel =  $Mujer_Movil/Rpta_Positiva/Label
	var RptaNegativaLabel =  $Mujer_Movil/Rpta_Negativa/Label
	
	RptaPositivaLabel.text = msg_sent_1_dict[item_enum][0]
	RptaNegativaLabel.text = msg_sent_1_dict[item_enum][1]

func show_player_reply_options():
	# Lista de nodos a mostrar suavemente, a: alfa 
	var nodos = [
		$Mujer_Movil/EsperandoRespuesta,
		$Mujer_Movil/Rpta_Positiva,
		$Mujer_Movil/Rpta_Negativa
	]
	
	fade_nodes(nodos, true, 0.42)

func handle_player_answer(inviteAccepted: bool):
	var nodos = [
		$Mujer_Movil/EsperandoRespuesta,
		$Mujer_Movil/Rpta_Positiva,
		$Mujer_Movil/Rpta_Negativa
	]
	
	fade_nodes(nodos, false, 0.42)
	GlobalManager.inviteAccepted = inviteAccepted

func fade_nodes(nodes: Array, showNode: bool, duration: float = 0.4):
	for nodo in nodes:
		if showNode:
			nodo.visible = true
			#nodo.modulate.a = 0.0
			#create_tween().tween_property(nodo, "modulate:a", 1.0, duration)
		else:
			#nodo.modulate.a = 1.0
			var tween = create_tween()
			tween.tween_property(nodo, "modulate:a", 0.0, duration)
			tween.finished.connect(func():
				nodo.visible = false
			)

func _on_rpta_positiva_pressed() -> void:
	handle_player_answer(true)

func _on_rpta_negativa_pressed() -> void:
	handle_player_answer(false)



func add_message(emisor: String, texto: String):
	var escena_burbuja
	
	match emisor:
		"match":
			if ultimo_emisor == "match":
				escena_burbuja = preload("res://scenes/chat/BurbujaMatch_SinAvatar.tscn").instantiate()
			else:
				escena_burbuja = preload("res://scenes/chat/BurbujaMatch_ConAvatar.tscn").instantiate()
		"player":
			if ultimo_emisor == "player":
				escena_burbuja = preload("res://scenes/chat/BurbujaJugador_SinAvatar.tscn").instantiate()
			else:
				escena_burbuja = preload("res://scenes/chat/BurbujaJugador_ConAvatar.tscn").instantiate()

	# Asignar texto
	var label = escena_burbuja.get_node("Burbuja/Texto")
	label.text = texto
	
	label.visible = true
	label.modulate.a = 1.0
	
	escena_burbuja.visible = true
	escena_burbuja.modulate.a = 1.0
	
	# Añadir al contenedor (sin tweens)
	$ScrollContainer/VBoxContainer.add_child(escena_burbuja)

	await get_tree().process_frame
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value




	# Añadir al contenedor
	#$ScrollContainer/VBoxContainer.add_child(escena_burbuja)
	
	#await get_tree().process_frame
	#$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value
	print("Tamaño mínimo:", escena_burbuja.get_minimum_size())
	print("Tamaño real:", escena_burbuja.get_size())
	print("ScrollContainer visible:", $ScrollContainer.visible)
	print("VBoxContainer visible:", $ScrollContainer/VBoxContainer.visible)
	
	print("ScrollContainer size:", $ScrollContainer.get_size())
	#print("VBoxContainer size:", $ScrollContainer.get_node("VBoxContainer").rect_size)
	print("ScrollContainer visible:", $ScrollContainer.visible)
	print("VBoxContainer visible:", $ScrollContainer.get_node("VBoxContainer").visible)
	var vbox = $ScrollContainer.get_node("VBoxContainer")
	print("Clase del nodo VBoxContainer:", vbox.get_class())
	print("Hereda Control?:", vbox is Control)



	
func mostrar_mensaje_match(texto: String):
	print("mostrando mensaje..", texto)
	add_message("match", texto)
	print("mensaje añadido a la UI")
	print("$ScrollContainer/VBoxContainer: ", $ScrollContainer/VBoxContainer)


func mostrar_mensaje_player(texto: String):
	add_message("player", texto)
