extends Node2D

@onready var Message1 = $Mujer_Movil.get_node("Message_Recieved1")
@onready var Message2 = $Mujer_Movil.get_node("Message_Recieved2")

@onready var Message1Label = Message1.get_node("Label")
@onready var Message2Label = Message2.get_node("Label")

var msg_recieved_1_dict: Dictionary
var msg_recieved_2_dict: Dictionary
var msg_sent_1_dict: Dictionary

var msg_r_1 = "¡Hola! ¿Qué tal? Vi en tu perfil que te gusta PLAYER_INTEREST"
var msg_r_2 = ""
var isWaitingReply: bool = true

#GlobalManager.INTERESES 

var interest_obtenido = ""

func _ready():
	# Primer mensaje del hombre
	msg_recieved_1_dict = {
		GlobalManager.INTERESES.DEPORTES: "hacer deporte.",
		GlobalManager.INTERESES.CINE: "ir al cine.", 
		GlobalManager.INTERESES.VIDEOJUEGOS: "los videojuegos.", 
		GlobalManager.INTERESES.ANIMES: "ver animes.",
		GlobalManager.INTERESES.LIBROS: "la lectura.",
		GlobalManager.INTERESES.COCINA: "cocinar. Niam",
		GlobalManager.INTERESES.FESTIVALES: "ir a festivales.",
		GlobalManager.INTERESES.MUSICA: "escuchar música",
		GlobalManager.INTERESES.TECH: "la tecnología"
	}
	
	# Segundo mensaje del hombre
	msg_recieved_2_dict = {
		GlobalManager.INTERESES.DEPORTES: "Entreno 3 veces por semana, ¿y tú?",
		GlobalManager.INTERESES.CINE:"Mi peli favorita es Freaky Friday ¿y la tuya?",
		GlobalManager.INTERESES.VIDEOJUEGOS: "Ahora juego a aventuras con buena historia.",
		GlobalManager.INTERESES.ANIMES: "Mi anime fav es Fullmetal Alchemist, ¿y el tuyo?",
		GlobalManager.INTERESES.LIBROS: "Ahora estoy con un libro de ciencia ficción.",
		GlobalManager.INTERESES.COCINA: "Ayer hice pasta casera, salió genial.",
		GlobalManager.INTERESES.FESTIVALES:  "El último que fui fue increíble.",
		GlobalManager.INTERESES.MUSICA: "Últimamente escucho mucho jazz fusión.",
		GlobalManager.INTERESES.TECH:  "Estoy probando un gadget nuevo muy útil."
	}

	# Respuestas de la chica (player)
	msg_sent_1_dict = {
		GlobalManager.INTERESES.DEPORTES: [
			"¡Genial! Yo también entreno, sobre todo yoga y running.",
			"No practico mucho deporte, la verdad."
		],
		GlobalManager.INTERESES.CINE: [
			"¡Me encanta esa película! También adoro la ciencia ficción.",
			"Prefiero las comedias, no soy muy fan de la ciencia ficción."
		],
		GlobalManager.INTERESES.VIDEOJUEGOS: [
			"¡Suena interesante! Me gustan los juegos con buena historia.",
			"No juego mucho, prefiero otras actividades."
		],
		GlobalManager.INTERESES.ANIMES: [
			"¡También lo veo! La historia me parece increíble.",
			"No me engancho mucho con los animes."
		],
		GlobalManager.INTERESES.LIBROS: [
			"Me encanta leer, sobre todo ciencia ficción y fantasía.",
			"No suelo leer mucho, apenas tengo tiempo."
		],
		GlobalManager.INTERESES.COCINA: [
			"¡Qué rico! Me encanta cocinar platos nuevos.",
			"No soy buena en la cocina, siempre termino pidiendo comida."
		],
		GlobalManager.INTERESES.FESTIVALES: [
			"¡Seguro fue increíble! Me encanta el ambiente de los festivales.",
			"Ya no voy tanto a festivales, me agota un poco."
		],
		GlobalManager.INTERESES.MUSICA: [
			"Me gusta el jazz, pero también escucho música indie.",
			"No soy muy fan del jazz, prefiero otros géneros."
		],
		GlobalManager.INTERESES.TECH: [
			"¡Qué guay! Me encanta probar tecnología nueva.",
			"No estoy tan al día con la tecnología."
		]
	}


	#var rand_idx = randi() % GlobalManager.main_character_intereses.size()
	var rand_item_str = "DEPORTES"#GlobalManager.main_character_intereses[rand_idx]
	var rand_item_enum = GlobalManager.INTERESES[rand_item_str]
	
	var new_message_1 = replace_message(msg_r_1, "PLAYER_INTEREST", msg_recieved_1_dict[rand_item_enum])
	var new_msg_r_2 = msg_recieved_2_dict[rand_item_enum]
	
	Message1Label.text = new_message_1
	Message2Label.text = new_msg_r_2

func replace_message(original_str, old_text, new_text):
	var new_str = original_str.replace(old_text, new_text)
	return new_str
