extends Node

@onready var menu_music = $MenuMusic
@onready var game_music = $GameMusic
@onready var plot_twist_music = $PlotTwistMusic
@onready var game_click_sfx = $GameClickSFX
@onready var man_reaction_sfx = $ManReactionSFX
@onready var woman_thinking_sfx = $WomanThinkingSFX
@onready var woman_dissapointed_sfx = $WomanDissapointedSFX
@onready var woman_excited_sfx = $WomanExcitedSFX
@onready var woman_busted_sfx = $WomanBustedSFX
@onready var cupid_app_camera_sfx = $CupidAppCameraSFX
@onready var cupid_app_click_sfx = $CupidAppClickSFX
@onready var cupid_app_typing_sfx = $CupidAppTypingSFX

var current_music = null
var sound_on = true

const MENU_VOLUME_DB = -22
const GAME_VOLUME_DB = -24
const PLOT_TWIST_VOLUME_DB = -12
const WOMAN_THINKING_DB = -30
# Duración del fade en segundos
const FADE_TIME = 0.22

func _ready():
	#print("AudioManager listo")
	play_menu_music()

func stop_all():
	if menu_music.playing:
		menu_music.stop()
	if game_music.playing:
		game_music.stop()
		woman_thinking_sfx.stop()
	if plot_twist_music.playing:
		plot_twist_music.stop()

func play_sfx(sfx: AudioStreamPlayer):
	sfx.play()
	
func stop_sfx(sfx: AudioStreamPlayer):
	sfx.stop()

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
	play_music_with_fade(woman_thinking_sfx, WOMAN_THINKING_DB)

func play_plot_twist_music():
	play_plot_twist_music_no_fade()

func play_game_click_sfx():
	play_sfx(game_click_sfx)

func play_cupid_app_click_sfx():
	play_sfx(cupid_app_click_sfx)

func play_cupid_app_typing_sfx():
	if not cupid_app_typing_sfx.playing:
		play_sfx(cupid_app_typing_sfx)
		
func cupid_app_open_camera_sfx():
	play_sfx(cupid_app_camera_sfx)
	
func play_man_reaction_sfx():
	if GlobalManager.inviteAccepted:
		man_reaction_sfx.stream = preload("res://assets/sfx/man/man_laughing.wav")
		man_reaction_sfx.volume_db = 0
	else:
		man_reaction_sfx.stream = preload("res://assets/sfx/man/man_growl.wav")
		man_reaction_sfx.volume_db = -20
	play_sfx(man_reaction_sfx)
	
func play_woman_dissapointed_sfx():
	play_sfx(woman_dissapointed_sfx)

func play_woman_excited_sfx():
	play_sfx(woman_excited_sfx)
	
func play_woman_busted_sfx():
	play_sfx(woman_busted_sfx)
	
func stop_cupid_app_typing_sfx():
	stop_sfx(cupid_app_typing_sfx)

func is_typing_sound_playing():
	return cupid_app_typing_sfx.playing
	
func toggle_sound():
	sound_on = !sound_on
	if sound_on:
		if current_music != null and not current_music.playing:
			current_music.play()
	else:
		stop_all()
		
func is_playing() -> bool:
	return current_music != null and current_music.playing

func wait_for_sfx_to_finish():
	return $AudioStreamPlayer.finished
	
