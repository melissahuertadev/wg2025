# GlobalManager - Singleton
extends Node

# Aqui se almacenan los intereses del jugador
enum INTERESES {DEPORTES, CINE, VIDEOJUEGOS, ANIMES, LIBROS, COCINA, FESTIVALES, MUSICA, TECH}

var game_language = "es"
var main_character_intereses = ["DEPORTES"]
var main_character_nombre = ""
var main_character_edad = 0 
var inviteAccepted = false
var match_messages = []
var player_messages = []

# scene
var audio_manager = null

func _ready():
	# Instancia la escena AudioManager y la agrega como hijo del árbol raíz
	var audio_scene = preload("res://scenes/AudioManager.tscn").instantiate()
	# call_deferred() hace que la función se ejecute después del frame actual
	# cuando Godot ya terminó de configurar el árbol de nodos y es seguro hacer cambios.
	get_tree().root.call_deferred("add_child", audio_scene)
	audio_manager = audio_scene

# Helper
func create_timer(timeInSeconds: float):
	return get_tree().create_timer(timeInSeconds).timeout
