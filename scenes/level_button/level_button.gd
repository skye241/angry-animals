extends TextureButton

@export var level_number: String = "1"
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var scorel_label: Label = $MarginContainer/VBoxContainer/ScorelLabel

func _ready() -> void:
	level_label.text = level_number
	scorel_label.text = str(ScoreManager.get_level_best(level_number))
	
func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)# Replace with function body.


func _on_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)# Replace with function body.
 # Replace with function body.


func _on_pressed() -> void:
	ScoreManager.level_selected = level_number
	get_tree().change_scene_to_file("res://scenes/level_base/level_%s.tscn" % level_number) # Replace with function body.
