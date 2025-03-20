extends StaticBody2D

class_name Cup

static var _num_cups: int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_num_cups += 1
	print("_num_cups:", _num_cups)
	
func die() -> void: 
	animation_player.play("vanish")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_num_cups -=1
	queue_free() # Replace with function body.
