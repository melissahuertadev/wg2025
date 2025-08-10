extends Node2D

@onready var Message1 = $Message_Recieved1
@onready var Message2 = $Message_Recieved2

@onready var Message1Label = Message1.get_node("Label1")
@onready var Message2Label = Message2.get_node("Label")

var saludo = "¡Hola! ¿Qué tal? Vi en tu perfil que te gusta PLAYER_INTEREST"
var message_2 = ""

#GlobalManager.INTERESES 
var message_1_dict: Dictionary = {
	"DEPORTES": "hacer deporte.",
	"CINE": "ir al cine.", 
	"VIDEOJUEGOS": "los videojuegos.", 
	"ANIMES": "ver animes.",
	"LIBROS": "la lectura.",
	"COCINA": "cocinar. Niam",
	"FESTIVALES": "ir a festivales.",
	"MUSICA": "escuchar musica",
	"TECH": "la tecnologia",
}

var message_2_dict: Dictionary = {
	"DEPORTES": "",
	"CINE": "", 
	"VIDEOJUEGOS": "", 
	"ANIMES": "",
	"LIBROS": "",
	"COCINA": "",
	"FESTIVALES": "",
	"MUSICA": "",
	"TECH": "",
}

var interest_obtenido = ""

var message_0 = "Mi género favorito es el de ciencia ficción de los 80."

func _ready():
	print("Message1", Message1)
	print("Message2", Message2)
	print("Label1", Message1Label)
	print("Label2", Message2Label)
	var rand_idx = randi() % GlobalManager.main_character_intereses.size()
	var rand_item = GlobalManager.main_character_intereses[rand_idx]

	var new_message_1 = replace_message(saludo, "PLAYER_INTEREST", message_1_dict[rand_item])
	var new_message_2 = replace_message(message_2, "", message_2_dict[rand_item])
	print("new message 1", new_message_1)
	print("new message 2", new_message_2)
	
	Message1Label.text = new_message_1

func replace_message(original_str, old_text, new_text):
	var new_str = original_str.replace(old_text, new_text)
	return new_str
