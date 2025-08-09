extends Node2D

func _on_continuar_button_pressed() -> void:
	print("Ir a registro")
	get_tree().change_scene_to_file("res://scenes/Pantalla1_Registro.tscn")
