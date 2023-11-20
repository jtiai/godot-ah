extends Control


const GAME_OVER_JINGLE = "res://assets/sfx/end.wav"

@onready var music_stream = AudioManager.get_music_stream()
@onready var name_edit = $CenterContainer/MarginContainer2/HBoxContainer/NameEdit

func _ready():
	name_edit.grab_focus()
	var tween = get_tree().create_tween()
	music_stream.volume_db = 0
	tween.tween_property(music_stream, "volume_db", -80, 2.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.play()


func _on_Tween_tween_completed(_object, _key):
	music_stream.stream_paused = true
	var stream = AudioManager.play_sound(GAME_OVER_JINGLE)
	stream.connect("finished",Callable(self,"_on_stream_finished"))


func _on_stream_finished():
	music_stream.stream_paused = false

	var tween = get_tree().create_tween()
	music_stream.volume_db = -80
	tween.tween_interval(3.0)
	tween.tween_property(music_stream, "volume_db", 0, 2.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.play()


func _on_Button_pressed():
	if name_edit.text.length() > 2:
		HighscoreManager.set_highscore(HighscoreManager.latest_score, name_edit.text)

	get_tree().change_scene_to_file("res://scenes/highscore.tscn")
