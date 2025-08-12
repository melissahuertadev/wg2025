extends Window

@onready var rich_text_label = $ColorRect/VBoxContainer/ScrollContainer/VBoxContainer/RichTextLabel

func _ready():
	connect("close_requested", Callable(self, "_on_close_requested"))
	set_credits_data(GlobalManager.game_language)

func load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		return JSON.parse_string(content)
	return {}

func set_credits_data(lang: String):
	var data = load_json("res://data/credits.json")
	if not data.has(lang):
		push_error("Idioma no encontrado en JSON: " + lang)
		return
	
	var c = data[lang]
	var bb_text = ""
	
	# Título centrado
	bb_text += "[center][b]" + c["title"] + "[/b][/center]\n"
	bb_text += c["subtitle"] + "\n"
	bb_text += c["subtitles"]["theme"] + ": \"" + c["theme"] + "\"\n"
	bb_text += c["description"] + "\n\n"
	
	# Integrantes
	bb_text += "[b]" + c["subtitles"]["members"] + "[/b]\n"
	for m in c["members"]:
		bb_text += m["name"] + " — " + m["role"] + "\n"
		for s in m["social"]:
			bb_text += s["platform"] + ": " + s["handle"] + "\n"
		bb_text += "\n"
	
	# Colaboraciones externas
	bb_text += "[b]" + c["subtitles"]["external_collab"] + "[/b]\n"
	for collab in c["external_collab"]:
		bb_text += collab["type"] + ": " + collab["credit"] + "\n"

	# Activar bbcode y aplicar mención en negrita
	rich_text_label.bbcode_enabled = true
	rich_text_label.bbcode_text = set_text_with_mentions(bb_text)

func set_text_with_mentions(text: String):	
	var pattern = r"(@[^\s]+)" #r"(@\w+)" 
	var regex = RegEx.new()
	regex.compile(pattern)
	var results = regex.search_all(text)
	for result in results:
		var word = result.get_string(1)
		text = text.replace(word, "[b]" + word + "[/b]")
	return text

func _on_texture_button_pressed() -> void:
	hide()

func _on_close_requested():
	hide()
