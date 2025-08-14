extends Control

@export var default_z_index := 10
@export var image_base_path := "res://assets/chat/notification/"

var game_lang = GlobalManager.game_language
var current_character_type = ""


func show_notification(character_type: String, parent_texture_rect: TextureRect = null):
	# character_type: "hija" o "novio"
	current_character_type = character_type

	# Utiliza el padre explicito, si no, se obtiene con get_parent()
	var parent_control: TextureRect = parent_texture_rect if parent_texture_rect else get_parent()
	if not (parent_control is TextureRect):
		push_error("Parent no es un TextureRect")
		return

	# Agregar esta escena como hijo del padre si aún no lo es
	if self.get_parent() != parent_control:
		parent_control.add_child(self)
		self.position = Vector2.ZERO  # se coloca en la esquina superior izquierda del padre

	update_dark_bg_size_and_position(parent_control)
	update_notification_image(character_type)
	show_elements()

	# call_deferred asegura que play_notification_sfx() se llame
	# después de que el nodo se agregue al árbol, incluso 
	# si se instancia la escena dinámicamente.
	call_deferred("play_notification_sfx")
	
func show_elements():
	$DarkBG.visible = true
	$DarkBG.get_node("Notification").visible = true

func play_notification_sfx():
	var sfx: AudioStreamPlayer = $PlotTwistNotificationSFX
	# verificar que la escena esté en el árbol
	#if is_inside_tree(): 
	sfx.play()


func _play_sfx_deferred(sfx):
	sfx.play()

func update_dark_bg_size_and_position(parent_control: TextureRect):
	# Tamaño del padre (Mujer_Movil)
	var dark_bg: ColorRect = $DarkBG
	var parent_size = parent_control.size
	print("parent control ", parent_control)
	
	dark_bg.size = parent_size * Vector2(0.95, 1)
	dark_bg.position = parent_size * Vector2(0.025, 0.015)
	dark_bg.z_index = default_z_index

func update_notification_image(character_type: String):
	var dark_bg: ColorRect = $DarkBG
	var phone_notification: TextureRect = dark_bg.get_node("Notification")
	# Notification solo en la parte superior
	var notif_size = Vector2(246, 77)
	phone_notification.size = notif_size
	phone_notification.position = Vector2((dark_bg.size.x - notif_size.x)/2, 10)
	
	# Asignar imagen (según idioma o tipo de mensaje)
	var img_path = image_base_path + character_type + "_" + game_lang + ".png"
	phone_notification.texture = load(img_path)
	phone_notification.z_index = default_z_index
	
func _notification(what):
	if what == NOTIFICATION_RESIZED and current_character_type != "":
		# recalcula posición y tamaño
		show_notification(current_character_type)
