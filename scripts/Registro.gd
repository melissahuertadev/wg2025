extends Node2D

var step := 0 # 0 = nombre, 1 = edad
var nombre := ""
var edad := 0
var typing_sound_active := false

@onready var indicacion_label = $Mujer_Movil/IndicacionLabel
@onready var text_input = $Mujer_Movil/Panel/TextEdit
@onready var continuar_button = $ContinuarButton
@onready var regresar_button = $RegresarButton
@onready var error_message = $Mujer_Movil/ErrorLabel
@onready var typing_timer: Timer = Timer.new()

func _ready():
	print(GlobalManager.main_character_edad, GlobalManager.main_character_nombre)
	# Timer para detectar pausas al escribir
	typing_timer.wait_time = 0.3 # 300ms sin escribir = parar sonido
	typing_timer.one_shot = true
	typing_timer.timeout.connect(_on_typing_stopped)
	add_child(typing_timer)
	
	mostrar_paso_nombre()
	continuar_button.disabled = true
	regresar_button.visible = false
	
func mostrar_paso_nombre():
	step = 0
	indicacion_label.text = "Ingresa tu nombre"
	text_input.placeholder_text = "Tu nombre"
	text_input.text = GlobalManager.main_character_nombre if GlobalManager.main_character_nombre != "" else ""
	text_input.editable = true
	
# 		continuar_button.disabled = false 
func mostrar_paso_edad():
	step = 1
	indicacion_label.text = "Ingresa tu edad"
	text_input.placeholder_text = "16"
	text_input.text = str(GlobalManager.main_character_edad) if GlobalManager.main_character_edad != 0 else ""
	text_input.editable = true
	regresar_button.visible = true 
	continuar_button.disabled = true

func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	if step == 0:
		mostrar_paso_edad()
	elif step == 1:
		get_tree().change_scene_to_file("res://scenes/Pantalla2_Intereses.tscn")


func _on_text_edit_text_changed() -> void:
	var new_text = text_input.text
	
	# Si el sonido no está ya sonando, reproducirlo
	if not typing_sound_active:
		GlobalManager.audio_manager.play_cupid_app_typing_sfx()
		typing_sound_active = true
	
	# Reinicia el timer cada vez que se detecta escritura
	typing_timer.start()
	
	if step == 0:
		# Validar que el nombre no esté vacío y tenga menos de 11 caracteres
		if new_text.strip_edges() != "" and new_text.length() <= 10:
			error_message.text = ""
			continuar_button.disabled = false
			GlobalManager.main_character_nombre = new_text.strip_edges()
		else:
			error_message.text = "Ingresa menos de 11 caracteres"
			continuar_button.disabled = true
	elif step == 1:
		# Validar que la edad sea un número >=16
		# Primero validar que solo tenga dígitos
		if new_text.is_valid_int():
			var edad_val = int(new_text)
			if edad_val < 16:
				error_message.text = "Debes ser mayor de 16"
				continuar_button.disabled = true
			elif edad_val > 90:
				error_message.text = "Debes ser menor de 90"
				continuar_button.disabled = true
			else:
				GlobalManager.main_character_edad = edad_val
				continuar_button.disabled = false
				error_message.text = ""
		else:
			continuar_button.disabled = true
	
# get_tree().change_scene_to_file("res://scenes/Pantalla0_Inicio.tscn")

func _on_typing_stopped():
	GlobalManager.audio_manager.stop_cupid_app_typing_sfx()
	typing_sound_active = false
	
func _on_regresar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	if step == 1:
		mostrar_paso_nombre()
		regresar_button.visible = false
