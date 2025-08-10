extends Node

@onready var label_nombre = $lbltexto
@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect

func _ready():
	label_nombre.text = GlobalManager.main_character_nombre

	await get_tree().create_timer(1).timeout

	var tween = create_tween()
	var viewport_size = get_viewport().size
	tween.tween_property(top_rect, "position", Vector2(0, -top_rect.size.y), 0.2)
	tween.parallel().tween_property(bottom_rect, "position", Vector2(0, viewport_size.y), 0.2)
