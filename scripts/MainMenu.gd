extends Node2D

# Pantalla de Inicio: "Empezar el juego, salir"
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla0_Inicio.tscn")
	print("Game started")

func _on_quit_button_pressed() -> void:
	print("Quiting... ")
	get_tree().quit()
