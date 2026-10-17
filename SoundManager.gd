extends Node

var sizzle_tween = Tween.new()
var sizzle_tween2 = Tween.new()

onready var main_music = $MusicPlayer
onready var piano_music = $PianoPlayer
onready var sizzle_sound = $SizzleSound
onready var sizzle_sound2 = $SizzleSound2
onready var drop_sound = $DropSound
onready var eat_sound = $EatSound
onready var happy_sound = $HappySound
onready var crunch_sound = $CrunchSound
onready var click_sound = $ClickSound
onready var sad_sound = $SadSound

onready var fade_tween = $FadeTween

func _ready():
	add_child(sizzle_tween)
	add_child(sizzle_tween2)


func play_music():
	if not main_music.playing:
		main_music.play()


func fade_out_music(duration):
	fade_tween.interpolate_property(
		main_music, "volume_db", 
		0, - 40, duration, 
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
	
	yield(get_tree().create_timer(duration), "timeout")
	
	fade_tween.remove_all()
	main_music.stop()
	main_music.volume_db = 0


func play_piano():
	piano_music.stop()
	piano_music.play()


func play_sizzle():
	sizzle_tween.stop_all()
	sizzle_sound.volume_db = 0
	sizzle_sound.stop()
	sizzle_sound.play()


func stop_sizzle():
	sizzle_tween.interpolate_property(
		sizzle_sound, "volume_db", 
		sizzle_sound.volume_db, 
		- 24, 
		1, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	sizzle_tween.start()


func play_sizzle2():
	sizzle_tween2.stop_all()
	sizzle_sound2.volume_db = 0
	sizzle_sound2.stop()
	sizzle_sound2.play()


func stop_sizzle2():
	sizzle_tween2.interpolate_property(
		sizzle_sound2, "volume_db", 
		sizzle_sound2.volume_db, 
		- 24, 
		1, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	sizzle_tween2.start()


func play_drop():
	drop_sound.pitch_scale = rand_range(1.0, 1.5)
	drop_sound.play()


func play_eat():
	eat_sound.play()


func play_happy():
	happy_sound.stop()
	happy_sound.play()


func play_crunch():
	crunch_sound.stop()
	crunch_sound.play()


func play_click():
	click_sound.stop()
	click_sound.play()


func play_sad():
	sad_sound.stop()
	sad_sound.play()
