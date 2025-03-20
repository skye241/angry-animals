extends Node2D

@onready var splash_sound: AudioStreamPlayer2D = $SplashSound
const ANIMAL = preload("res://scenes/animal/animal.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_class("RigidBody2D"):
		splash_sound.position = body.position  
		splash_sound.play()
		
