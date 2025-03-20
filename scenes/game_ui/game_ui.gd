extends Control

@onready var attempt_label: Label = $MarginContainer/VBoxContainer/AttemptLabel

var _attempts: int = -1

func _enter_tree() -> void:
	SignalHub.on_attempt_made.connect(update_attempt)

func _ready() -> void:
	update_attempt()
	
func update_attempt() -> void:
	_attempts += 1
	attempt_label.text = "Attempt: %s " % _attempts
