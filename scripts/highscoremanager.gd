extends Node

const HIGHSCORE_FILE = "user://highscores.dat"

var highscores = []
var latest_score = -1


func _ready():
	var file = File.new()
	if not file.file_exists(HIGHSCORE_FILE):
		create_highscores()

	file.open(HIGHSCORE_FILE, File.READ)
	highscores = parse_json(file.get_as_text())
	file.close()

		
func create_highscores():
	for i in 20:
		highscores.append([0, "Janze"])
	save_highscores()


func save_highscores():
	var file = File.new()
	file.open(HIGHSCORE_FILE, File.WRITE)
	file.store_string(to_json(highscores))
	file.close()
	

func is_highscore(user_score) -> bool:
	for score_and_name in highscores:
		var score = [0]
		if user_score > score:
			return true

	return false


func set_highscore(user_score, name):
	for i in highscores.size():
		var score = highscores[i][0]
		if score < user_score:
			highscores.insert(i, [user_score, name])
			highscores.pop_back()  # Remove last one
			save_highscores()
			break
