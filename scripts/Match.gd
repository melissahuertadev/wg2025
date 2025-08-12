extends Node2D

func _ready() -> void:
	GlobalManager.audio_manager.woman_thinking_sfx.stop()
		
func _on_continuar_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla4_Chat.tscn")
