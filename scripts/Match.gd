extends Node2D

@onready var match_text = $Mujer_Movil/MatchText
@onready var match_sfx = $AudioStreamPlayer

func _ready() -> void:
	GlobalManager.audio_manager.woman_thinking_sfx.stop()
	match_text.show()
	$AnimationPlayer.play("MatchAppear")
	match_sfx.play()
		
func _on_continuar_button_pressed() -> void:
	GlobalManager.audio_manager.play_cupid_app_click_sfx()
	get_tree().change_scene_to_file("res://scenes/Pantalla5_Chat.tscn")
