extends Node2D

const PICK_SOUND = "res://assets/sfx/pick.wav"
const BUBBLE_SOUND = "res://assets/sfx/bubble.wav"

signal bubble_died(object)
signal bubble_picked(bubble)

onready var tween = $Tween
onready var bubble = $Sprite
onready var timer = $Timer

var points setget ,points_get

var rng = RandomNumberGenerator.new()
var rotation_speed: float


func _ready():
	rng.randomize()
	timer.wait_time = rng.randf_range(3.0, 7.0)
	timer.start()
	rotation_degrees = rng.randf_range(0.0, 360.0)
	rotation_speed = rng.randf_range(-2.0, 1.0)
	if rotation_speed >= -0.5:
		rotation_speed += 1.0
	rotation_speed = rad2deg(rotation_speed)
	tween.interpolate_property(bubble, 'scale', Vector2(1, 1), Vector2(0, 0), timer.wait_time, Tween.TRANS_LINEAR)
	tween.start()
	AudioManager.play_sound(BUBBLE_SOUND)

	
func _process(delta):
	rotation_degrees += rotation_speed * delta
	

func points_get():
	return max(int(timer.wait_time / timer.time_left * 20), 1)


func _on_Tween_tween_completed(object, _key):
	emit_signal("bubble_died", object)


func _on_CollectArea_body_entered(_body: Node):
	AudioManager.play_sound(PICK_SOUND)
	emit_signal("bubble_picked", self)
