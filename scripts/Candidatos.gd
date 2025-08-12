extends Node2D

@onready var image_candidato = $Mujer_Movil
@onready var boton_si = $Mujer_Movil/Rpta_Positiva
@onready var boton_no =  $Mujer_Movil/Rpta_Negativa
@onready var animation_player = $AnimationPlayer

var candidatos = ["res://assets/candidates/candidato1.png", "res://assets/candidates/candidato2.png", "res://assets/candidates/candidato3.png"]
var candidato_actual = 0
var opciones = {
	"no_match": ["Sí, me gustaría", "No… no es mi tipo"],
	"match": ["¡Sí, definitivamente!", "Mmm… podría ser"]
}

func _ready():
	mostrar_candidato(candidato_actual)
	boton_si.get_node("Label").text = opciones["no_match"][0]
	boton_no.get_node("Label").text = opciones["no_match"][1]
	
func mostrar_candidato(index):
	# Cambiar la textura del TextureRect
	image_candidato.texture = load(candidatos[index])
	
	# Reproducir animación fade in
	animation_player.play("fade_in")

func procesar_opcion(opcion):	
	candidato_actual += 1
	if candidato_actual < candidatos.size():
		if candidato_actual == candidatos.size() - 1:
			boton_si.get_node("Label").text = opciones["match"][0]
			boton_no.get_node("Label").text = opciones["match"][1]
		mostrar_candidato(candidato_actual)
	else:
		get_tree().change_scene_to_file("res://scenes/Pantalla3_Match.tscn")

func _on_rpta_positiva_pressed() -> void:
	procesar_opcion(1)

func _on_rpta_negativa_pressed() -> void:
	procesar_opcion(2)
