extends Node2D

@onready var trigger: Area2D = $Trigger
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	trigger.body_entered.connect(close)


func close(_body: Node2D) -> void:
	print("Test")
	animated_sprite.play("close")
