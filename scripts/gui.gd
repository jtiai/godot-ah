extends Control


onready var speedometer = $VBoxContainer/MarginContainer/SpeedoMeter


func _ready():
	speedometer.value = 0.0
