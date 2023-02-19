extends Node


func _input(event):
	if event.is_action_pressed("action_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
