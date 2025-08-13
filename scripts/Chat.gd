extends Node2D

signal bubble_animation_finished

@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect

var game_lang = GlobalManager.game_language
var ultimo_emisor = null # "match" o "player"
var isWaitingReply: bool = false
var msg_recieved_1_dict: Dictionary
var msg_recieved_2_dict: Dictionary
var player_decisions_1_dict: Dictionary
var msg_sent_1_dict: Dictionary

var isWaitingResponseLabel = ""
var msg_r_1 = ""
var msg_r_2 = ""
var rand_item_enum = ""
var SHORT_WAITING_TIME = 0.75
var LONG_WAITING_TIME = 1.25

func _ready():
	ultimo_emisor = null
	load_dictionaries(game_lang)
	# Conectar señal solo una vez acá (antes de cargar mensajes)
	self.connect("bubble_animation_finished", Callable(self, "_on_bubble_animation_finished"))

	set_labels_text()
	
func replace_message(original_str, old_text, new_text):
	var new_str = original_str.replace(old_text, new_text)
	return new_str

func load_dictionaries(lang_code := "es"):
	var file_path = "res://data/messages_%s.json" % lang_code
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY:
			msg_r_1 = data["msg_r_1"]
			msg_recieved_1_dict = {}
			msg_recieved_2_dict = {}
			player_decisions_1_dict = {}
			msg_sent_1_dict = {}

			# Primer mensaje del hombre
			for key in data["msg_recieved_1"]:
				msg_recieved_1_dict[GlobalManager.INTERESES.get(key)] = data["msg_recieved_1"][key]

			# Segundo mensaje del hombre
			for key in data["msg_recieved_2"]:
				msg_recieved_2_dict[GlobalManager.INTERESES.get(key)] = data["msg_recieved_2"][key]

			# Opciones de respuesta de la chica (player)
			for key in data["player_decisions_1"]:
				player_decisions_1_dict[GlobalManager.INTERESES.get(key)] = data["player_decisions_1"][key]

			# Respuesta en burbuja de la chica
			for key in data["msg_sent_1"]:
				msg_sent_1_dict[GlobalManager.INTERESES.get(key)] = data["msg_sent_1"][key]
				
			isWaitingResponseLabel = data["waiting_response"]
		else:
			push_error("JSON inválido en %s" % file_path)
	else:
		push_error("No se pudo abrir %s" % file_path)

func load_player_options(action_name: String) -> void:
	if action_name == "first":
		self.connect("bubble_animation_finished", Callable(self, "_on_bubble_animation_finished"))

func get_rand_item_enum():
	var rand_idx = randi() % GlobalManager.main_character_intereses.size()
	var rand_item_str = GlobalManager.main_character_intereses[rand_idx]
	#var rand_item_str = "DEPORTES" # PARA TESTEAR
	var rand_item_en = GlobalManager.INTERESES[rand_item_str]
	
	return rand_item_en

# Mostrar los mensajes iniciales del "match" y Setear las respuestas posibles del jugador
func set_labels_text():
	rand_item_enum = get_rand_item_enum()
	
	await load_initial_match_messages(rand_item_enum)
	set_rptas_text(rand_item_enum)

func load_initial_match_messages(item_enum):
	ultimo_emisor = ""
	var new_message_1 = replace_message(msg_r_1, "PLAYER_INTEREST", msg_recieved_1_dict[item_enum])
	var new_message_2 = msg_recieved_2_dict[item_enum]

	GlobalManager.match_messages.push_back(new_message_1)
	GlobalManager.match_messages.push_back(new_message_2)
	await show_match_message(new_message_1)
	await GlobalManager.create_timer(SHORT_WAITING_TIME)
	await show_match_message(new_message_2)
	
	#TODO: use when there is more than one interaction
	#load_player_options("first")

func load_initial_player_messages(item_enum) -> void:
	ultimo_emisor = ""
	var player_message = msg_sent_1_dict[item_enum][0] if GlobalManager.inviteAccepted else msg_sent_1_dict[item_enum][1]
	
	# Esperar que termine show_player_message
	GlobalManager.player_messages.push_back(player_message)
	await show_player_message(player_message)
	play_player_sfx(false)
	
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

	# Cambiar texto del Label en el nodo "EsperandoRespuesta"
	var isWaitingResponseNode = nodos[0].get_node("Label")
	isWaitingResponseNode.text = isWaitingResponseLabel
	# "waiting_response" 
	fade_nodes(nodos, true, 0.42)

func handle_player_answer(inviteAccepted: bool):
	GlobalManager.inviteAccepted = inviteAccepted
	GlobalManager.audio_manager.play_game_click_sfx()
	
	# Hide options
	var nodos = [
		$Mujer_Movil/EsperandoRespuesta,
		$Mujer_Movil/Rpta_Positiva,
		$Mujer_Movil/Rpta_Negativa
	]
	
	await GlobalManager.create_timer(SHORT_WAITING_TIME)
	fade_nodes(nodos, false, 0.42)
	await load_initial_player_messages(rand_item_enum)
	
func handle_plot_twist_notification():
	await GlobalManager.create_timer(LONG_WAITING_TIME)
	show_boyfriend_message()
	await play_player_sfx(true)
	await GlobalManager.create_timer(LONG_WAITING_TIME)
	show_continue_button()
	
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

# Funciones del Jugador/Player (mujer)
func show_player_message(texto: String):
	await show_bubble_message("player", texto)

func play_player_sfx(isLastMessage: bool):
	if GlobalManager.inviteAccepted and isLastMessage:
		GlobalManager.audio_manager.play_woman_busted_sfx()
	elif GlobalManager.inviteAccepted and not isLastMessage:
		GlobalManager.audio_manager.play_woman_excited_sfx()
	elif not GlobalManager.inviteAccepted and isLastMessage:
		GlobalManager.audio_manager.play_woman_excited_sfx()
	else:
		GlobalManager.audio_manager.play_woman_disappointed_sfx()

# Funciones del plot twist (novio)
func show_boyfriend_message():
	var plot_twist_scene = preload("res://scenes/chat/PlotTwistNotification.tscn")
	var plot_twist = plot_twist_scene.instantiate()

	add_child(plot_twist) # Lo agregas a la escena actual

	
	
	
	# Mostrar las texturas del plot twist
	var mujer_movil = $Mujer_Movil
	#var dark_bg = mujer_movil.get_node("PlotTwist")
	#var notification = dark_bg.get_node("Notification")
	
	# Reproducir sonido antes de mostrar la notificación
	#var sfx = mujer_movil.get_node("PlotTwistNotificationSFX")
	#sfx.play()
	
	# Asignar imagen (según idioma o tipo de mensaje)
	#var img_path = "res://assets/chat/notification/novio_" + game_lang + ".png"
	#notification.texture = load(img_path)
	#dark_bg.visible = true
	#notification.visible = true
	
	# Ajustar z_index para que estén por encima
	$ScrollContainer.z_index = 0
	plot_twist.show_notification("novio") # aquí le pasas el tipo
	#dark_bg.z_index = 10
	#notification.z_index = 10
	$Mujer_Manos.z_index = 20
	

func show_continue_button():
	# Mostrar boton CONTINUAR
	var continue_btn = $ContinuarButton
	continue_btn.z_index = 30
	continue_btn.visible = true
		
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
	#print("ultimo emisor ? ", ultimo_emisor)

func show_match_message(texto: String):
	var mujer_movil = $Mujer_Movil
	var sfx = mujer_movil.get_node("MatchMessageSFX")
	sfx.play()
	await show_bubble_message("match", texto)

func handle_flow(inviteAccepted: bool):
	await handle_player_answer(inviteAccepted)
	handle_plot_twist_notification()

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
	handle_flow(true)

func _on_rpta_negativa_pressed() -> void:
	handle_flow(false)

func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
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
