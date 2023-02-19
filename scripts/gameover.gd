extends Control


const GAME_OVER_JINGLE = "res://assets/sfx/end.wav"

onready var tween: Tween = $Tween
onready var tween_2: Tween = $Tween2
onready var music_stream = AudioManager.get_music_stream()
onready var name_edit = $CenterContainer/MarginContainer2/HBoxContainer/NameEdit

func _ready():
	name_edit.grab_focus()
	var _val = tween.interpolate_property(music_stream, "volume_db", 0, -80, 2.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_val = tween.start()


func _on_Tween_tween_completed(_object, _key):
	music_stream.stream_paused = true
	var stream = AudioManager.play_sound(GAME_OVER_JINGLE)
	stream.connect("finished", self, "_on_stream_finished")


func _on_stream_finished():
	music_stream.stream_paused = false
	var _val = tween_2.interpolate_property(music_stream, "volume_db", -80, 0, 2.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3.0)
	_val = tween_2.start()


func _on_Button_pressed():
	if name_edit.text.length() > 2:
		HighscoreManager.set_highscore(HighscoreManager.latest_score, name_edit.text)

	var _val = get_tree().change_scene("res://scenes/highscore.tscn")
