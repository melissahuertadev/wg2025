extends Node

@onready var label_nombre = $lbltexto
@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect
@onready var saludo = $lbl_saludo
@onready var invitacion = $lbl_invitacion
@onready var respuesta = $lbl_respuesta
#@onready var reas = $lbl_reas

func _ready():
	GlobalManager.audio_manager.play_plot_twist_music()
	label_nombre.text = GlobalManager.main_character_nombre
	saludo.text = GlobalManager.match_messages[0]
	invitacion.text=GlobalManager.match_messages[1]
	respuesta.text=GlobalManager.player_messages[0]
	await get_tree().create_timer(1).timeout
		
	var tween = create_tween()
	var viewport_size = get_viewport().size
	tween.tween_property(top_rect, "position", Vector2(0, -top_rect.size.y), 0.2)
	tween.parallel().tween_property(bottom_rect, "position", Vector2(0, viewport_size.y), 0.2)

func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	print("to final")
	get_tree().change_scene_to_file("res://scenes/Pantalla_Final.tscn")
