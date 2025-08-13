extends Control

@export var default_z_index := 10
@export var image_base_path := "res://assets/chat/notification/"

var game_lang = GlobalManager.game_language

func _ready():
	set_deferred("size", get_viewport().size)

func show_notification(character_type: String):
	# character_type: "hija" o "novio"
	var dark_bg = $DarkBG
	var notification = dark_bg.get_node("Notification")
	var sfx = $PlotTwistNotificationSFX

	# Reproducir sonido antes de mostrar la notificación
	sfx.play()

	# Asignar imagen (según idioma o tipo de mensaje)
	var img_path = image_base_path + character_type + "_" + game_lang + ".png"
	notification.texture = load(img_path)

	# Mostrar elementos
	dark_bg.visible = true
	notification.visible = true

	# Ajustar z_index
	dark_bg.z_index = default_z_index
	notification.z_index = default_z_index
