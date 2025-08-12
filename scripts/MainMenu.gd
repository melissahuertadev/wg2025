extends Node2D

# Pantalla de Inicio: "Jugar y Creditos"

func _ready() -> void:
	print("MainMenu listo")
	GlobalManager.audio_manager.play_menu_music()

	
func _on_play_button_pressed() -> void:
	#print("Game started")
	GlobalManager.audio_manager.play_game_music()
	get_tree().change_scene_to_file("res://scenes/Pantalla0_Inicio.tscn")

#func _on_quit_button_pressed() -> void:
	#get_tree().quit()

func _on_credits_button_pressed() -> void:
	var credits_modal_instance = preload("res://scenes/CreditsModal.tscn").instantiate()
	add_child(credits_modal_instance)
	credits_modal_instance.popup_centered()
