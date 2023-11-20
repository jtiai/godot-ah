extends Node2D

const WORM_SOUND = "res://assets/sfx/player.wav"
const UPDATE_SPEED = 0.1 / 60.0
const MIN_DIST = 10.0
const MAX_DIST = 20.0
const WORM_NORMAL_SPEED = 0.98 * 60
const WORM_SLOW_SPEED = 0.90 * 60
const WORM_SPEED_LOW = 0.50
const WORM_SPEEDUP = 1.5
const WORM_SPEED_LIMIT = WORM_SPEEDUP * 5.0

@onready var wormie = $CharacterBody2D

var movement_speed: float = 0
var movement_speed_factor: float = 0
var movement_target: Vector2 = Vector2.ZERO

var pieces = []
var movement_sound: AudioStreamPlayer


func _ready():
	pieces.push_back($Parts/Sprite1)
	pieces.push_back($Parts/Sprite2)
	pieces.push_back($Parts/Sprite3)
	pieces.push_back($Parts/Sprite4)
	pieces.push_back($Parts/Sprite5)

	movement_sound = AudioManager.play_sound(WORM_SOUND)
	movement_sound.volume_db = -80

func _process(delta):
	var tgt = wormie.global_position
	pieces[0].global_position = tgt
	for i in range(1, 5):
		var src = pieces[i].global_position
		src = lerp(src, tgt, UPDATE_SPEED * delta)
		var dst = tgt - src
		var length = dst.length_squared()
		if length > MAX_DIST * MAX_DIST:
			var dst2 = Vector2(dst)
			dst = dst.normalized() * MAX_DIST
			src += dst2 - dst
		elif length < MIN_DIST * MIN_DIST:
			var dst2 = Vector2(dst)
			dst = dst.normalized() * MIN_DIST
			src += dst2 - dst
		pieces[i].global_position = src
		tgt = src

	var cur_vec = pieces[0].position

	var dist_squared = movement_target.distance_squared_to(cur_vec)
	if dist_squared <= 2:
		movement_speed_factor = WORM_SLOW_SPEED
	if movement_speed > 0:
		movement_speed = movement_speed * movement_speed_factor * delta
		movement_sound.volume_db = 0 - WORM_SPEED_LIMIT * 2
	if movement_speed < WORM_SPEED_LOW:
		movement_speed = 0.0
		movement_sound.stream_paused = true


func _input(event):
	if event.is_action_pressed("action_click"):
		movement_speed_factor = WORM_NORMAL_SPEED
		movement_target = get_local_mouse_position() - pieces[0].position
		movement_target = movement_target.normalized()
		if movement_speed <= WORM_SPEED_LIMIT:
			movement_speed += WORM_SPEEDUP
			movement_sound.stream_paused = false


func _physics_process(_delta):
	var collision_info = wormie.move_and_collide(movement_target * movement_speed)
	if collision_info:
		movement_target = movement_target.bounce(collision_info.get_normal())


func die():
	movement_sound.stop()
	AudioManager.free_stream(movement_sound)
