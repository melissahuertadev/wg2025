extends Node

@onready var label_nombre = $Hombre_Movil/JugadorLabel
@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect
@onready var saludo = $lbl_saludo
@onready var invitacion = $lbl_invitacion
@onready var respuesta = $lbl_respuesta
@onready var continue_btn = $ContinuarButton

var SHORT_WAITING_TIME = 0.75
var LONG_WAITING_TIME = 1.25
var notification_type = "hija"

func _ready():
	GlobalManager.audio_manager.play_plot_twist_music()
	label_nombre.text = GlobalManager.main_character_nombre
	saludo.text = GlobalManager.match_messages[0]
	invitacion.text = GlobalManager.match_messages[1]
	respuesta.text = GlobalManager.player_messages[0]

	await GlobalManager.create_timer(LONG_WAITING_TIME)
	
	var tween = create_tween()
	var viewport_size = get_viewport().size
	tween.tween_property(top_rect, "position", Vector2(0, -top_rect.size.y), 0.2)
	tween.parallel().tween_property(bottom_rect, "position", Vector2(0, viewport_size.y), 0.2)
	await GlobalManager.create_timer(LONG_WAITING_TIME)
	
	show_plot_twist_notification()
	await GlobalManager.create_timer(LONG_WAITING_TIME)
	show_continue_button()

# Funciones del plot twist (hija)
func show_plot_twist_notification():
	var plot_twist_scene = preload("res://scenes/chat/PlotTwistNotification.tscn")
	var plot_twist_instance = plot_twist_scene.instantiate()

	#add_child(plot_twist)
	plot_twist_instance.show_notification(notification_type, $Hombre_Movil)
	
	# Ajustar z_index para que estén por encima
	#$ScrollContainer.z_index = 0
	$Hombre_Manos.z_index = 20
	
func show_continue_button():
	# Mostrar boton CONTINUAR
	continue_btn.z_index = 30
	continue_btn.visible = true

func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	get_tree().change_scene_to_file("res://scenes/Pantalla_Final.tscn")
