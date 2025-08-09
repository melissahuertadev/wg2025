extends Node2D

@onready var continuarButton = $ContinuarButton

func _ready():
	continuarButton.disabled = true
	#print(">> intereses: ", GlobalManager.main_character_intereses)

func enable_button():
	continuarButton.disabled = false

func disable_button():
	continuarButton.disabled = true
	
func _on_continuar_button_pressed() -> void:
	print("> Mostrar Candidatos")
	get_tree().change_scene_to_file("res://scenes/Pantalla2_Candidato.tscn")

func handle_interest(param):
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

func _on_interes_videojuegos_pressed() -> void:
	var videojuegos = GlobalManager.INTERESES.keys()[1]
	handle_interest(videojuegos)

func _on_interes_libros_pressed() -> void:
	var libros = GlobalManager.INTERESES.keys()[2]
	handle_interest(libros)

func _on_interes_cocina_pressed() -> void:
	var cocina = GlobalManager.INTERESES.keys()[3]
	handle_interest(cocina)

func _on_interes_cine_pressed() -> void:
	var cine = GlobalManager.INTERESES.keys()[4]
	handle_interest(cine)

func _on_interes_anime_pressed() -> void:
	var anime = GlobalManager.INTERESES.keys()[5]
	handle_interest(anime)
