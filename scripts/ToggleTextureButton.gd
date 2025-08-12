extends TextureButton

@export var texture_normal_res: Texture
@export var texture_pressed_res: Texture

var isToggled = false

func _ready():
	isToggled = false
	self.texture_normal = texture_normal_res
	self.texture_pressed = texture_pressed_res
	update_texture()

func _pressed():
	isToggled = !isToggled
	update_texture()

func update_texture():
	if isToggled:
		self.texture_normal = texture_pressed_res
	else:
		self.texture_normal = texture_normal_res
