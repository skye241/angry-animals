extends Resource

class_name LevelScoreResource

const DEFAULT_SCORE = 1000

@export var level_scores: Dictionary[String, int]

func get_level_best(level: String) -> int:
	return level_scores.get(level, DEFAULT_SCORE)

func update_level_score(level: String, score: int) -> void:
	var best = get_level_best(level)
	if best > score:
		level_scores[level] = score
		
func level_exist(level: String) -> bool:
	return level in level_scores
