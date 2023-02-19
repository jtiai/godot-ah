extends Node2D

const NORMAL_BUBBLE = preload("res://scenes/normal-bubble.tscn")
const SPECIAL_BUBBLE = preload("res://scenes/special-bubble.tscn")
const TIMER_SOUND = "res://assets/sfx/time-end-alert.wav"

onready var bubbles = $Bubbles
onready var wormie = $Wormie
onready var speedometer = $CanvasLayer/GUI/VBoxContainer/MarginContainer/SpeedoMeter
onready var score_txt = $CanvasLayer/GUI/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/Score
onready var timer_txt = $CanvasLayer/GUI/VBoxContainer/HBoxContainer/MarginContainer3/HBoxContainer/TimeLeft
onready var gametimer = $GameTimer

var current_song = 0
var rng = RandomNumberGenerator.new()
var score: int = 0
var previous_time = -1
var current_time = -1

func _ready():
	randomize()
	rng.randomize()
	current_time = round(gametimer.time_left)
	var next_bubble_time = rng.randf_range(1.5, 5.0)  # First bubble
	yield(get_tree().create_timer(next_bubble_time), "timeout")
	create_bubble()
			

func _process(_delta):
	speedometer.value = wormie.movement_speed
	current_time = round(gametimer.time_left)
	timer_txt.text = str(current_time)
	if  current_time < 6 and current_time != previous_time:
		previous_time = current_time
		AudioManager.play_sound(TIMER_SOUND)

func create_bubble():
	var new_bubble_pos: Vector2
	var accepted_pos = false

	# Ensure enough distance between bubbles
	while not accepted_pos:
		accepted_pos = true
		new_bubble_pos = Vector2(rng.randi_range(50, 590), rng.randi_range(50, 430))
		if new_bubble_pos.distance_squared_to(wormie.position) < 32 * 32 * 2:
			accepted_pos = false
			continue

		for bubble in bubbles.get_children():
			if new_bubble_pos.distance_squared_to(bubble.position) < 32 * 32 * 2:
				accepted_pos = false
				break

	var bubble_instance = null
	if rng.randi_range(0, 10) == 0:
		bubble_instance = SPECIAL_BUBBLE.instance()
	else:
		bubble_instance = NORMAL_BUBBLE.instance()
	bubble_instance.position = new_bubble_pos

	bubbles.add_child(bubble_instance)
	bubble_instance.connect("bubble_died",bubbles.get_parent(),"_on_bubble_died")
	bubble_instance.connect("bubble_picked",bubbles.get_parent(),"_on_bubble_picked")
	var next_bubble_time = rng.randf_range(0.5, 2.0)
	yield(get_tree().create_timer(next_bubble_time), "timeout")
	create_bubble()


func _on_bubble_died(object):
	# TODO: spawn next bubble.
	object.scale = Vector2(1, 1)
	object.get_parent().queue_free()


func _on_bubble_picked(bubble: Node2D):
	if bubble.BUBBLE_TYPE == "normal":
		score += int(max(bubble.timer.wait_time / bubble.timer.time_left * 20.0, 1))
		score_txt.text = "%05d" % score
	elif bubble.BUBBLE_TYPE == "special":
		gametimer.start(gametimer.time_left + rng.randf_range(5.0, 15.0))
	bubble.call_deferred("free")


func _on_GameTimer_timeout():
	# Game over
	HighscoreManager.latest_score = score
	wormie.die()
	var _val = get_tree().change_scene("res://scenes/gameover.tscn")
