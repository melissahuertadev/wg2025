extends Node

@onready var label_nombre = $JugadorLabel
@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect
@onready var saludo = $lbl_saludo
@onready var invitacion = $lbl_invitacion
@onready var respuesta = $lbl_respuesta
#@onready var reas = $lbl_reas

var SHORT_WAITING_TIME = 0.75
var LONG_WAITING_TIME = 1.25

func _ready():
	GlobalManager.audio_manager.play_plot_twist_music()
	label_nombre.text = GlobalManager.main_character_nombre
	saludo.text = GlobalManager.match_messages[0]
	invitacion.text=GlobalManager.match_messages[1]
	respuesta.text=GlobalManager.player_messages[0]

	await GlobalManager.create_timer(LONG_WAITING_TIME)
	
	var tween = create_tween()
	var viewport_size = get_viewport().size
	tween.tween_property(top_rect, "position", Vector2(0, -top_rect.size.y), 0.2)
	tween.parallel().tween_property(bottom_rect, "position", Vector2(0, viewport_size.y), 0.2)
	await GlobalManager.create_timer(LONG_WAITING_TIME)
	
	print("segundo timer, mostrar notificacion de hija ")

# Funciones del plot twist (hija)
func show_plot_twist_notification():
	# Mostrar las texturas del plot twist
	var hombre_movil = $Hombre_Movil
	var dark_bg = hombre_movil.get_node("PlotTwist")
	var notification = dark_bg.get_node("Notification")
	
	# Reproducir sonido antes de mostrar la notificación
	var sfx = hombre_movil.get_node("PlotTwistNotificationSFX")
	sfx.play()
	
	# Asignar imagen (según idioma o tipo de mensaje)
	var img_path = "res://assets/chat/notification/hija_" + game_lang + ".png"
	notification.texture = load(img_path)
	dark_bg.visible = true
	notification.visible = true
	
	# Ajustar z_index para que estén por encima
	$ScrollContainer.z_index = 0
	dark_bg.z_index = 10
	notification.z_index = 10
	$Mujer_Manos.z_index = 20


func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	print("to final")
	get_tree().change_scene_to_file("res://scenes/Pantalla_Final.tscn")
