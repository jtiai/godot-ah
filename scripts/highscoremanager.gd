extends Node

const HIGHSCORE_FILE = "user://highscores.dat"

var highscores = []
var latest_score = -1


func _ready():
	if not FileAccess.file_exists(HIGHSCORE_FILE):
		create_highscores()

	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	highscores = test_json_conv.get_data()
	file = null


func create_highscores():
	for i in 20:
		highscores.append([0, "Janze"])
	save_highscores()


func save_highscores():
	var file = FileAccess.open(HIGHSCORE_FILE, FileAccess.WRITE)
	file.store_string(JSON.new().stringify(highscores))
	file = null;


func is_highscore(user_score) -> bool:
	for score_and_name in highscores:
		var score = [0]
		if user_score > score:
			return true

	return false


func set_highscore(player_score, player_name):
	for i in highscores.size():
		var score = highscores[i][0]
		if score < player_score:
			highscores.insert(i, [player_score, player_name])
			highscores.pop_back()  # Remove last one
			save_highscores()
			break
