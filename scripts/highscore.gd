extends Node2D

const HIGHSCORE_MUSIC = "res://assets/music/trouble-in-a-digital-city.ogg"

onready var tween = $Tween
onready var tween2 = $Tween2
onready var label = $MainLabel
onready var music_stream = AudioManager.get_music_stream()

var target_y
var repeat_y
var scroll_ratio
var bg_music_stream
var stage = 1

func _ready():
	var s = ""
	for i in HighscoreManager.highscores.size():
		var score = HighscoreManager.highscores[i][0]
		var name = HighscoreManager.highscores[i][1]

		s += "%02d • %05d • %s\n" % [i + 1, score, name]

	label.text = s + s

	repeat_y = label.rect_position.y - label.rect_size.y / 2 - 1
	target_y = -(label.rect_size.y-480)

	var pixels_to_scroll = label.rect_size.y - 480
	var pixels_to_scroll_repeat =  target_y - repeat_y
	scroll_ratio = abs(pixels_to_scroll_repeat / pixels_to_scroll)
	tween.interpolate_property(label, "rect_position:y", label.rect_position.y-480, target_y, 20.0)
	tween.start()
	tween2.interpolate_property(music_stream, "volume_db", 0, -80, 2.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween2.start()


func _input(event):
	if event.is_action_pressed("action_click"):
		stage = 2
		tween2.interpolate_property(bg_music_stream, "volume_db", 0, -80, 2.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween2.start()
		

func _on_Tween_tween_completed(_object, _key):
	tween.interpolate_property(label, "rect_position:y", repeat_y, target_y, 20.0 * scroll_ratio)
	tween.start()


func _on_Tween2_tween_completed(_object, _key):
	if stage == 1:
		bg_music_stream = AudioManager.play_sound(HIGHSCORE_MUSIC)
		bg_music_stream.connect("finished", self, "_on_bg_music_finished")
	elif stage == 2:
		stage = 3
		tween2.interpolate_property(music_stream, "volume_db", -80, 0, 2.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween2.start()
	elif stage == 3:
		var _val = get_tree().change_scene("res://scenes/titlescreen.tscn")

func _on_bg_music_finished():
	yield(get_tree().create_timer(10.0), "timeout")
	bg_music_stream.play()
