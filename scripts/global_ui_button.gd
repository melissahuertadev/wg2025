extends TextureButton

@export var normal_color: Color = Color("3FB4F3")
@export var pressed_color: Color = Color("FD6A7F")
@export var grow_scale: float = 1.05
@export var anim_speed: float = 0.1
@export var border_color: Color = Color.BLACK
@export var border_width: float = 2.0

func _ready():
	self.modulate = normal_color
	connect("button_down", Callable(self, "_on_button_down"))
	connect("button_up", Callable(self, "_on_button_up"))

func _on_button_down():
	GlobalManager.audio_manager.play_game_click_sfx()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * grow_scale, anim_speed)
	tween.tween_property(self, "modulate", pressed_color, anim_speed)

func _on_button_up():
	var tween = create_tween()
	tween.tween_interval(0.1) # pequeña pausa para que se vea
	tween.tween_property(self, "scale", Vector2.ONE, anim_speed)
	tween.tween_property(self, "modulate", normal_color, anim_speed)
