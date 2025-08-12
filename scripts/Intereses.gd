# TODO: mantener imagen del boton mientras esta seleccionado

extends Node2D

@onready var continuarButton = $ContinuarButton

func _ready():
	continuarButton.disabled = true
	#print(">> intereses: ", GlobalManager.main_character_intereses)

func enable_button():
	continuarButton.disabled = false

func disable_button():
	continuarButton.disabled = true

func handle_interest(param):
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	#print("handle interest ", param)
	if GlobalManager.main_character_intereses.has(param):
		var index = GlobalManager.main_character_intereses.rfind(param)
		GlobalManager.main_character_intereses.remove_at(index)
	else:
		GlobalManager.main_character_intereses.push_back(param)
	handle_button()
 
func handle_button():
	#print('count', GlobalManager.main_character_intereses.size())
	if GlobalManager.main_character_intereses.size() > 0:
		enable_button()
	else:
		disable_button()
	
func _on_interes_deportes_pressed() -> void:
	var deporte = GlobalManager.INTERESES.keys()[0]
	handle_interest(deporte)

func _on_interes_cine_pressed() -> void:
	var cine = GlobalManager.INTERESES.keys()[1]
	handle_interest(cine)
	
func _on_interes_videojuegos_pressed() -> void:
	var videojuegos = GlobalManager.INTERESES.keys()[2]
	handle_interest(videojuegos)

func _on_interes_anime_pressed() -> void:
	var anime = GlobalManager.INTERESES.keys()[3]
	handle_interest(anime)
	
func _on_interes_libros_pressed() -> void:
	var libros = GlobalManager.INTERESES.keys()[4]
	handle_interest(libros)

func _on_interes_cocina_pressed() -> void:
	var cocina = GlobalManager.INTERESES.keys()[5]
	handle_interest(cocina)

func _on_interes_festivales_pressed() -> void:
	var festivales = GlobalManager.INTERESES.keys()[6]
	handle_interest(festivales)

func _on_interes_musica_pressed() -> void:
	var interes = GlobalManager.INTERESES.keys()[7]
	handle_interest(interes)

func _on_interes_tech_pressed() -> void:
	var interes = GlobalManager.INTERESES.keys()[8]
	handle_interest(interes)

func _on_continuar_button_pressed() -> void:
	#print("> Ir a escena 'Candidato'")
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	get_tree().change_scene_to_file("res://scenes/Pantalla3_Candidato.tscn")

func _on_retroceder_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	get_tree().change_scene_to_file("res://scenes/Pantalla1_RegistroEdad.tscn")
