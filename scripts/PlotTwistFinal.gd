extends Node

@onready var label_nombre = $lbltexto
@onready var top_rect = $CanvasLayer/TopRect
@onready var bottom_rect = $CanvasLayer/BottomRect

func _ready():
	label_nombre.text = ""

	var viewport_size = get_viewport().size

	top_rect.position = Vector2(0, 0)
	bottom_rect.position = Vector2(0, viewport_size.y / 2)

	await get_tree().process_frame

	top_rect.position = Vector2(0, -top_rect.size.y)
	bottom_rect.position = Vector2(0, viewport_size.y)

	var tween = create_tween()
	var centro_top = Vector2(0, viewport_size.y / 2 - top_rect.size.y)
	var centro_bottom = Vector2(0, viewport_size.y / 2)

	tween.tween_property(top_rect, "position", centro_top, 0.3)
	tween.parallel().tween_property(bottom_rect, "position", centro_bottom, 0.3)

	tween.finished.connect(_on_animacion_terminada)

func _on_animacion_terminada():
	label_nombre.text = GlobalManager.main_character_nombre

	await get_tree().create_timer(1).timeout

	var tween = create_tween()
	var viewport_size = get_viewport().size
	tween.tween_property(top_rect, "position", Vector2(0, -top_rect.size.y), 0.3)
	tween.parallel().tween_property(bottom_rect, "position", Vector2(0, viewport_size.y), 0.3)
