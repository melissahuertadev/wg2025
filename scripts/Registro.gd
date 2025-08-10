extends Node2D

@onready var input_nombre = $txt_nombre
@onready var input_edad = $txt_edad


func _on_btn_back_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla0_Inicio.tscn")

func _on_btn_go_edad_pressed() -> void:
	GlobalManager.main_character_nombre = input_nombre.text.strip_edges()
	print("Nombre guardado:", GlobalManager.main_character_nombre)
	get_tree().change_scene_to_file("res://scenes/Pantalla1_RegistroEdad.tscn")

func _on_btn_back_nombre_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla1_RegistroNombre.tscn")

func _on_btn_go_intereses_pressed() -> void:
	GlobalManager.main_character_edad = int(input_edad.text.strip_edges())
	print("Edad guardada:", GlobalManager.main_character_edad)
	get_tree().change_scene_to_file("res://scenes/Pantalla2_Intereses.tscn")
