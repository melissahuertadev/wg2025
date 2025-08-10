extends Node2D

@onready var mensajeFinal = $Dark/MensajeFinal

func _ready() -> void:
	if GlobalManager.inviteAccepted:
		mensajeFinal.text = "Fin de la partida. Has llegado al final de la historia. Aunque ganaste la confianza y lograste la cita, la verdad se ha revelado. A veces, nada es lo que parece."
	else:
		mensajeFinal.text = "Has esquivado una bala. Descubriste una verdad peligrosa."

	await get_tree().create_timer(2.0).timeout
	display_final_message()
	
func _on_quit_button_pressed() -> void:
	print("Quiting... ")
	get_tree().quit()


func display_final_message():
	var final_message = $Dark
	final_message.visible = true
