extends Node
@onready var label_nombre = $lbltexto

func _ready():
	label_nombre.text =  GlobalManager.main_character_nombre
