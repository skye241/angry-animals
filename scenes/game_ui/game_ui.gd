extends Control

@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var attempt_label: Label = $MarginContainer/VBoxContainer/AttemptLabel
@onready var music: AudioStreamPlayer2D = $Music
@onready var v_box_container_2: VBoxContainer = $MarginContainer/VBoxContainer2

var _attempts: int = -1

func _enter_tree() -> void:
	SignalHub.on_attempt_made.connect(update_attempt)
	SignalHub.on_cup_destroyed.connect(on_cup_destroyed)

func _ready() -> void:
	level_label.text = "Level %s" % ScoreManager.level_selected
	update_attempt()
	
func update_attempt() -> void:
	_attempts += 1
	attempt_label.text = "Attempt: %s " % _attempts
	
func on_cup_destroyed(remaining_cups: int) -> void:
	if remaining_cups == 0:
		music.play()
		v_box_container_2.show()
		ScoreManager.set_score_for_level(ScoreManager.level_selected, _attempts)
