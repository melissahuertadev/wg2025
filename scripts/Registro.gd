extends Node2D

func _on_btn_back_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla0_Inicio.tscn")

func _on_btn_go_intereses_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla2_Intereses.tscn")
