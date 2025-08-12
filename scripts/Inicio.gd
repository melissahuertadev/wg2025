extends Node2D

func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	# print("Ir a registro")
	get_tree().change_scene_to_file("res://scenes/Pantalla1_Registro.tscn")
