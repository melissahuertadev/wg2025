extends Node

@onready var menu_music = $MenuMusic
@onready var game_music = $GameMusic
@onready var plot_twist_music = $PlotTwistMusic

var current_music = null
var sound_on = true

const MENU_VOLUME_DB = -22
const GAME_VOLUME_DB = -24
const PLOT_TWIST_VOLUME_DB = -12
# Duración del fade en segundos
const FADE_TIME = 0.22

func _ready():
	print("AudioManager listo")
	play_menu_music()

func stop_all():
	if menu_music.playing:
		menu_music.stop()
	if game_music.playing:
		game_music.stop()
	if plot_twist_music.playing:
		plot_twist_music.stop()

func play_music_with_fade(new_music: AudioStreamPlayer, target_volume_db: float) -> void:
	if not sound_on:
		return
	
	if current_music == new_music:
		return
	
	var previous_music = current_music
	current_music = new_music
	
	if previous_music != null and previous_music.playing:
		# Hacer fade out
		var tween = create_tween()
		tween.tween_property(previous_music, "volume_db", -42, FADE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(func():
			_on_fade_out_finished(previous_music, new_music, target_volume_db)
		)
	else:
		# Si no hay música previa, simplemente empieza la nueva con fade in
		start_fade_in(new_music, target_volume_db)

func play_plot_twist_music_no_fade():
	if not sound_on:
		return
	stop_all()
	plot_twist_music.volume_db = PLOT_TWIST_VOLUME_DB
	plot_twist_music.play()
	current_music = plot_twist_music

func start_fade_in(music: AudioStreamPlayer, target_volume_db: float) -> void:
	music.volume_db = -80 # Muy bajo
	music.play()
	var tween = create_tween()
	tween.tween_property(music, "volume_db", target_volume_db, FADE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_fade_out_finished(previous_music: AudioStreamPlayer, new_music: AudioStreamPlayer, target_volume_db: float) -> void:
	previous_music.stop()
	start_fade_in(new_music, target_volume_db)

# Métodos para llamar externamente
func play_menu_music():
	play_music_with_fade(menu_music, MENU_VOLUME_DB)
	
func play_game_music():
	play_music_with_fade(game_music, GAME_VOLUME_DB)

func play_plot_twist_music():
	play_plot_twist_music_no_fade()
	
func toggle_sound():
	sound_on = !sound_on
	if sound_on:
		if current_music != null and not current_music.playing:
			current_music.play()
	else:
		stop_all()
		
func is_playing() -> bool:
	return current_music != null and current_music.playing
