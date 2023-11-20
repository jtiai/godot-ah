extends Control

@onready var fader = $Fader


func _ready():
	AudioManager.queue_music("res://assets/music/bouncing-around-in-pixel-town.ogg")
	AudioManager.queue_music("res://assets/music/carefree-days-in-groovyville.ogg")
	AudioManager.queue_music("res://assets/music/city-of-tomorrow.ogg")
	AudioManager.queue_music("res://assets/music/cyber-teen.ogg")
	AudioManager.queue_music("res://assets/music/pelican-bay-tiki-party.ogg")
	AudioManager.shuffle_music_queue()
	AudioManager.start_music()

	fader.color = Color(0, 0, 0, 1)
	var tween = get_tree().create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(fader, 'color', Color(0, 0, 0, 0), 5.0)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.play()


func _input(event):
	if event.is_action_pressed("action_click"):
		var _val = get_tree().change_scene_to_file("res://scenes/countdown.tscn")
	elif event.is_action_pressed("action_quit"):
		get_tree().quit()
