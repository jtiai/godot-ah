extends Node2D

const BUBBLE_TYPE = "special"

const PICK_SOUND = "res://assets/sfx/pick.wav"
const BUBBLE_SOUND = "res://assets/sfx/bubble.wav"

signal bubble_died(object)
signal bubble_picked(bubble)

@onready var bubble = $Sprite2D
@onready var timer = $Timer

var points :
	get:
		return max(int(timer.wait_time / timer.time_left * 20), 1)


var rng = RandomNumberGenerator.new()
var rotation_speed: float


func _ready():
	rng.randomize()
	timer.wait_time = rng.randf_range(3.0, 7.0)
	timer.start()
	rotation = rng.randf_range(0.0, deg_to_rad(360.0))
	rotation_speed = rng.randf_range(deg_to_rad(-2.0), deg_to_rad(1.0))
	if rotation_speed >= deg_to_rad(-0.5):
		rotation_speed += deg_to_rad(1.0)

	scale = Vector2(1, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(bubble, 'scale', Vector2(0, 0), timer.wait_time)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.play()
	AudioManager.play_sound(BUBBLE_SOUND)


func _process(delta):
	rotation += rotation_speed * delta


func _on_Tween_tween_completed(object, _key):
	emit_signal("bubble_died", object)


func _on_CollectArea_body_entered(_body: Node):
	AudioManager.play_sound(PICK_SOUND)
	emit_signal("bubble_picked", self)
