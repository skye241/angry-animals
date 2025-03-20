extends Node

const SCORES_PATH  = "user://animals.tres"
var _level_score : LevelScoreResource

var level_selected: String = "1":
	get:
		return level_selected
	set(new):
		level_selected = new

func _ready() -> void:
	load_scores()
	
func load_scores() -> void:
	if ResourceLoader.exists(SCORES_PATH): 
		_level_score = load(SCORES_PATH)
	print(_level_score)
	if !_level_score:
		_level_score = LevelScoreResource.new()


func set_score_for_level(level: String, score: int)	-> void: 
	_level_score.update_level_score(level, score)
	save_scores()

func get_level_best(level: String) -> int:
	return _level_score.get_level_best(level)

func save_scores() -> void: 
	ResourceSaver.save(_level_score, SCORES_PATH)
