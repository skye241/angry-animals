extends Node

signal on_animal_died
signal on_attempt_made

func emit_on_animal_died() -> void:
	on_animal_died.emit()

func emit_on_attempt_made() -> void:
	on_attempt_made.emit()
