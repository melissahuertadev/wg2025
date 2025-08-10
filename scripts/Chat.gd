extends Node2D

signal bubble_animation_finished

@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect

var ultimo_emisor = null # "match" o "player"
var isWaitingReply: bool = false
var msg_recieved_1_dict: Dictionary
var msg_recieved_2_dict: Dictionary
var player_decisions_1_dict: Dictionary
var msg_sent_1_dict: Dictionary

var msg_r_1 = "¡Hola! ¿Qué tal? Vi en tu perfil que te gusta PLAYER_INTEREST"
var msg_r_2 = ""
var rand_item_enum = ""

func _ready():
	ultimo_emisor = null
	load_dictionaries()
	# Conectar señal solo una vez acá (antes de cargar mensajes)
	self.connect("bubble_animation_finished", Callable(self, "_on_bubble_animation_finished"))

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
	player_decisions_1_dict = {
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
	
	# Respuesta en burbuja de la chica
	msg_sent_1_dict = {
		GlobalManager.INTERESES.DEPORTES: [
			"¡Genial! Me encantaría correr contigo este finde.",
			"Lo siento, me lesioné y necesito descansar."
		],
		GlobalManager.INTERESES.CINE: [
			"¡Perfecto! Me encantaría ir al cine contigo.",
			"No puedo, ya vi esa película."
		],
		GlobalManager.INTERESES.VIDEOJUEGOS: [
			"¡De una! Me apunto para jugar contigo.",
			"No juego mucho, pero gracias."
		],
		GlobalManager.INTERESES.ANIMES: [
			"¡Claro! Ver anime contigo sería genial.",
			"No veo anime, pero gracias."
		],
		GlobalManager.INTERESES.LIBROS: [
			"¡Vamos a la feria de libros juntos!",
			"No podré ir esta vez, pero gracias."
		],
		GlobalManager.INTERESES.COCINA: [
			"¡Sí! Cocinar juntos suena divertido.",
			"No me animo a cocinar hoy."
		],
		GlobalManager.INTERESES.FESTIVALES: [
			"¡Obvio! Me encantan los festivales.",
			"No me siento con ánimos para ir."
		],
		GlobalManager.INTERESES.MUSICA: [
			"¡Sí! Ir al concierto será genial.",
			"No puedo esta vez, pero gracias."
		],
		GlobalManager.INTERESES.TECH: [
			"¡Perfecto! Me interesa mucho la expo.",
			"No es lo mío, pero gracias."
		]
}


func load_player_options(action_name: String) -> void:
	if action_name == "first":
		self.connect("bubble_animation_finished", Callable(self, "_on_bubble_animation_finished"))
		#show_player_reply_options()

func get_rand_item_enum():
	var rand_idx = randi() % GlobalManager.main_character_intereses.size()
	var rand_item_str = GlobalManager.main_character_intereses[rand_idx]
	#var rand_item_str = "DEPORTES" # PARA TESTEAR
	var rand_item_en = GlobalManager.INTERESES[rand_item_str]
	
	return rand_item_en

func set_labels_text():
	rand_item_enum = get_rand_item_enum()
	
	load_initial_match_messages(rand_item_enum)
	set_rptas_text(rand_item_enum)

func load_initial_match_messages(item_enum):
	ultimo_emisor = ""
	var new_message_1 = replace_message(msg_r_1, "PLAYER_INTEREST", msg_recieved_1_dict[item_enum])
	var new_message_2 = msg_recieved_2_dict[item_enum]

	await show_match_message(new_message_1)
	await show_match_message(new_message_2)
	GlobalManager.match_messages.push_back(new_message_1)
	GlobalManager.match_messages.push_back(new_message_2)
	#load_player_options("first")

func load_initial_player_messages(item_enum, inviteAccepted) -> void:
	ultimo_emisor = ""

	var player_message = msg_sent_1_dict[item_enum][0] if inviteAccepted else msg_sent_1_dict[item_enum][1]
	print("rand_item_enum... ", rand_item_enum)
	print("msg... ", player_message)
	# Esperar que termine show_player_message
	await show_player_message(player_message)
	GlobalManager.player_messages.push_back(player_message)
	
	# Mostrar las texturas del plot twist
	var mujer_movil = $Mujer_Movil
	var dark_bg = mujer_movil.get_node("PlotTwist")
	var notification = dark_bg.get_node("Notification")
	
	# Reproducir sonido antes de mostrar la notificación
	var sfx = mujer_movil.get_node("PlotTwistNotificationSFX")
	sfx.play()
	
	dark_bg.visible = true
	notification.visible = true
	
	# Ajustar z_index para que estén por encima
	$ScrollContainer.z_index = 0
	dark_bg.z_index = 10
	notification.z_index = 10
	$Mujer_Manos.z_index = 20
	
	# Mostrar boton CONTINUAR
	var continue_btn = $ContinuarButton
	continue_btn.z_index = 30
	continue_btn.visible = true
	
func set_rptas_text(item_enum):
	var RptaPositivaLabel =  $Mujer_Movil/Rpta_Positiva/Label
	var RptaNegativaLabel =  $Mujer_Movil/Rpta_Negativa/Label
	
	RptaPositivaLabel.text = player_decisions_1_dict[item_enum][0]
	RptaNegativaLabel.text = player_decisions_1_dict[item_enum][1]

func show_player_reply_options():
	# Lista de nodos a mostrar suavemente, a: alfa 
	var nodos = [
		$Mujer_Movil/EsperandoRespuesta,
		$Mujer_Movil/Rpta_Positiva,
		$Mujer_Movil/Rpta_Negativa
	]
	
	fade_nodes(nodos, true, 0.42)

func handle_player_answer(inviteAccepted: bool):
	# Hide options
	var nodos = [
		$Mujer_Movil/EsperandoRespuesta,
		$Mujer_Movil/Rpta_Positiva,
		$Mujer_Movil/Rpta_Negativa
	]
	
	fade_nodes(nodos, false, 0.42)
	GlobalManager.inviteAccepted = inviteAccepted
	load_initial_player_messages(rand_item_enum, inviteAccepted)

func fade_nodes(nodes: Array, showNode: bool, duration: float = 1.542):
	for nodo in nodes:
		if showNode:
			nodo.visible = true
			nodo.modulate.a = 0.0
			var tween = create_tween()
			tween.tween_property(nodo, "modulate:a", 1.0, duration)
		else:
			var tween = create_tween()
			tween.tween_property(nodo, "modulate:a", 0.0, duration)
			tween.finished.connect(func():
				nodo.visible = false
			)

func load_bubble_scene(emisor: String, ult_em: String = "") -> Node:
	var escena_burbuja: Node
	
	var ue = ult_em if ult_em != null else ""
	
	match emisor:
		"match":
			if ue == "match":
				escena_burbuja = preload("res://scenes/chat/BurbujaMatch_SinAvatar.tscn").instantiate()
			else:
				escena_burbuja = preload("res://scenes/chat/BurbujaMatch_ConAvatar.tscn").instantiate()
		"player":
			if ue == "player":
				escena_burbuja = preload("res://scenes/chat/BurbujaJugador_SinAvatar.tscn").instantiate()
			else:
				escena_burbuja = preload("res://scenes/chat/BurbujaJugador_ConAvatar.tscn").instantiate()
		_:
			push_error("Emisor desconocido: %s" % emisor)
			return null
	
	return escena_burbuja

func set_bubble_text(escena_burbuja: Node, texto: String) -> void:
	var burbuja = escena_burbuja.get_node("Burbuja")
	var label = burbuja.get_node("Texto")
	label.text = texto

func prepare_bubble_animation(escena_burbuja: Node) -> void:
	# Inicializar alfa y escala para animación
	var burbuja = escena_burbuja.get_node("Burbuja")
	burbuja.modulate.a = 0.0
	burbuja.scale = Vector2(0.8, 0.8)

func play_bubble_animation(escena_burbuja: Node) -> void:
	var burbuja = escena_burbuja.get_node("Burbuja")
	var tween = create_tween()
	tween.tween_property(burbuja, "modulate:a", 1.0, 0.84)
	tween.tween_property(burbuja, "scale", Vector2(1, 1), 0.4)
	tween.finished.connect(Callable(self, "_on_tween_finished"))

# Mostrar Burbuja verde, rosa segun el emisor, estas burbujas son escenas creadas
func show_bubble_message(emisor: String, texto: String) -> void:
	var escena_burbuja = load_bubble_scene(emisor, safe_string(ultimo_emisor))

	set_bubble_text(escena_burbuja, texto)
	prepare_bubble_animation(escena_burbuja)
	$ScrollContainer/VBoxContainer.add_child(escena_burbuja) # Añadir burbuja al contenedor visible
	
	# Agregar espacio de 20 px entre mensajes
	var espacio = Control.new()
	espacio.custom_minimum_size = Vector2(0, 20)
	$ScrollContainer/VBoxContainer.add_child(espacio)
	
	play_bubble_animation(escena_burbuja)
	
	# Esperar un frame para que actualice scroll
	await get_tree().process_frame
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value
	ultimo_emisor = emisor
	print("ultimo emisor ? ", ultimo_emisor)

func show_match_message(texto: String):
	var mujer_movil = $Mujer_Movil
	var sfx = mujer_movil.get_node("MatchMessageSFX")
	sfx.play()
	await show_bubble_message("match", texto)

func show_player_message(texto: String):
	await show_bubble_message("player", texto)

# Helper
func safe_string(value) -> String:
	return value if value != null else ""
	
# Signals
func _on_tween_finished() -> void:
	emit_signal("bubble_animation_finished")
	
func _on_bubble_animation_finished():
	isWaitingReply = true
	show_player_reply_options()
	self.disconnect("bubble_animation_finished", Callable(self, "_on_bubble_animation_finished"))

func _on_rpta_positiva_pressed() -> void:
	handle_player_answer(true)

func _on_rpta_negativa_pressed() -> void:
	handle_player_answer(false)


func _on_continuar_button_pressed() -> void:
	top_rect.visible = true
	bottom_rect.visible = true
	
	var viewport_size = get_viewport().size
	top_rect.position = Vector2(0, 0)
	bottom_rect.position = Vector2(0, viewport_size.y / 2)

	await get_tree().process_frame

	top_rect.position = Vector2(0, -top_rect.size.y)
	bottom_rect.position = Vector2(0, viewport_size.y)

	var tween = create_tween()
	var centro_top = Vector2(0, viewport_size.y / 2 - top_rect.size.y)
	var centro_bottom = Vector2(0, viewport_size.y / 2)

	tween.tween_property(top_rect, "position", centro_top, 0.3)
	tween.parallel().tween_property(bottom_rect, "position", centro_bottom, 0.3)
	tween.finished.connect(_on_animacion_terminada)
	
	
func _on_animacion_terminada():
	await get_tree().change_scene_to_file("res://scenes/Pantalla5_PlotTwist.tscn")
