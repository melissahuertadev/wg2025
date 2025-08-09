extends Node2D

# .keys()[0]

func _on_continue_button_pressed() -> void:
	print("> Mostrar Candidatos")
	get_tree().change_scene_to_file("res://scenes/Pantalla_Candidato.tscn")
