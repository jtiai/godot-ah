extends Node

var num_channels = 10
var bus = "master"

var available = []
var queue = []

var music_player 
var playlist = []
var played = []

func _ready():
	randomize()

	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.connect("finished", self, "_on_music_finished", [music_player])
	music_player.bus = bus

	for i in num_channels:
		var sound_player = AudioStreamPlayer.new()
		add_child(sound_player)
		available.append(sound_player)
		sound_player.bus = bus
		var _val = sound_player.connect("finished", self, "_on_stream_finished", [sound_player])
	

func _on_music_finished(_stream):
	var previous_song = playlist.pop_back()
	played.append(previous_song)
	play_music(previous_song)


func queue_music(sound_path):
	playlist.append(sound_path)


func shuffle_music_queue():
	playlist.shuffle()


func _on_stream_finished(stream):
	available.append(stream)


func play_sound(sound_path):
	if not available.empty():
		var p = available.pop_front()
		p.stream = load(sound_path)
		p.play()
		return p
	else:
		queue.append(sound_path)
	return null


func free_stream(stream):
	available.append(stream)


func start_music():
	_on_music_finished(music_player)


func play_music(sound_path):
	if music_player.playing:
		music_player.stop()
	music_player.stream = load(sound_path)
	music_player.play()


func get_music_stream():
	return music_player


func _on_songs_played():
	var last = played.pop_back()
	played.shuffle()
	playlist = played
	playlist.append(last)
	played = []


func _process(_delta):
	if not queue.empty() and not available.empty():
		var p = available.pop_front()
		var s = queue.pop_front()
		p.stream = load(s)
		p.play()
