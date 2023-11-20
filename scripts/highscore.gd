extends Node2D

const HIGHSCORE_MUSIC = "res://assets/music/trouble-in-a-digital-city.ogg"


@onready var label = $MainLabel
@onready var music_stream = AudioManager.get_music_stream()

var target_y
var repeat_y
var scroll_ratio
var bg_music_stream
var stage = 1

func _ready():
	var s = ""
	for i in HighscoreManager.highscores.size():
		var player_score = HighscoreManager.highscores[i][0]
		var player_name = HighscoreManager.highscores[i][1]

		s += "%02d ★ %05d ★ %s\n" % [i + 1, player_score, player_name]

	label.text = s + s

	repeat_y = label.position.y - label.size.y / 2 - 1
	target_y = -(label.size.y-480)
	print(repeat_y, target_y)

	var pixels_to_scroll = label.size.y - 480
	var pixels_to_scroll_repeat =  target_y - repeat_y
	scroll_ratio = abs(pixels_to_scroll_repeat / pixels_to_scroll)

	var scroll_tween = get_tree().create_tween()
	scroll_tween.tween_property(label, "position:y", target_y, 20.0)
	scroll_tween.tween_callback(_on_scroll_tween_completed)

	var music_tween = get_tree().create_tween()
	music_stream.volume_db = 0
	music_tween.tween_property(music_stream, "volume_db", -80, 2.5)
	music_tween.set_trans(Tween.TRANS_LINEAR)
	music_tween.set_ease(Tween.EASE_IN_OUT)
	music_tween.tween_callback(_on_game_music_fadeout_completed)


func _input(event):
	if event.is_action_pressed("action_click"):
		stage = 2
		var tween = get_tree().create_tween()
		bg_music_stream.volume_db = 0
		tween.tween_property(bg_music_stream, "volume_db", -80, 2.5)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(_on_hiscore_music_fadeout_tween_completed)


func _on_scroll_tween_completed():
	label.position.y = repeat_y
	var tween = get_tree().create_tween()
	tween.tween_property(label, "position:y", target_y, 20.0 * scroll_ratio)
	tween.tween_callback(_on_scroll_tween_completed)

func _on_game_music_fadeout_completed():
	bg_music_stream = AudioManager.play_sound(HIGHSCORE_MUSIC)
	bg_music_stream.connect("finished", _on_bg_music_finished)


func _on_hiscore_music_fadeout_tween_completed():
	var tween = get_tree().create_tween()
	music_stream.volume_db = -80
	tween.tween_property(music_stream, "volume_db", 0, 2.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_on_music_fadein_tween_completed)

func _on_music_fadein_tween_completed():
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")

func _on_bg_music_finished():
	await get_tree().create_timer(10.0).timeout
	bg_music_stream.play()
