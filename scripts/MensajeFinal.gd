extends Node2D

@onready var mensajeFinal = $Dark/MensajeFinal
@onready var selfie = $SelfieTextureRect
@onready var circle_rect = $CircleRect
@onready var shader_mat = circle_rect.material
@onready var tween = get_tree().create_tween()

func _ready() -> void:
	if GlobalManager.inviteAccepted:
		mensajeFinal.text = "Fin de la partida. Has llegado al final de la historia. Aunque ganaste la confianza y lograste la cita, la verdad se ha revelado. A veces, nada es lo que parece."
	else:
		mensajeFinal.text = "Has esquivado una bala. Descubriste una verdad peligrosa."
	
	# Comienza cerrado
	shader_mat.set_shader_parameter("radius", 0.0)
	abrir_circulo()
	
	GlobalManager.audio_manager.cupid_app_open_camera_sfx()
	GlobalManager.audio_manager.play_man_reaction_sfx()
	await get_tree().create_timer(2.0).timeout
	display_final_message()
	
func abrir_circulo() -> void:
	var tween = create_tween()
	tween.tween_method(
		func(value): shader_mat.set_shader_parameter("radius", value),
		0.0, # valor inicial
		1.0, # valor final
		1.5  # duración
	)
	
func _on_quit_button_pressed() -> void:
	#print("Quiting... ")
	GlobalManager.audio_manager.play_game_click_sfx()
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(self._on_timer_timeout)

func display_final_message():
	var final_message = $Dark
	final_message.visible = true

func _on_timer_timeout():
	get_tree().quit()
