extends Control


@onready var speedometer = $MarginContainer/VBoxContainer/MarginContainer/SpeedoMeter


func _ready():
	speedometer.value = 0.0
