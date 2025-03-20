extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
const MAIN = preload("res://scenes/main/main.tscn")
const ANIMAL = preload("res://scenes/animal/animal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_animal() # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_packed(MAIN)
		


func _enter_tree() -> void:
	SignalHub.on_animal_died.connect(spawn_animal)

func spawn_animal() -> void: 
	var new_animal = ANIMAL.instantiate()
	new_animal.position = marker_2d.position
	add_child(new_animal)
