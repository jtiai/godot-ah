extends Control


@onready var label = $CenterContainer/Label

var counts = [
	"GO!", "1", "2", "3", "4", "5"
]

const TICK = "res://assets/sfx/clock-tick.wav"

func _ready():
	label.text = counts.pop_back()
	AudioManager.play_sound(TICK)

func _on_Timer_timeout():
	if not counts.is_empty():
		label.text = counts.pop_back()
		AudioManager.play_sound(TICK)
	else:
		var _val = get_tree().change_scene_to_file("res://scenes/main-game.tscn")
