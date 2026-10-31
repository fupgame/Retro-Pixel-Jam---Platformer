class_name Cutscene extends Node2D

signal start_game_request

@onready var text_label: Label = %TextLabel
@onready var type_sfx: AudioStreamPlayer = $TypeSFX
@onready var cutscene_animation: AnimatedSprite2D = $CutsceneAnimation
@onready var note: TextureRect = $CanvasLayer/Note

@export var _speed_type: float = 2.0

var _last_character_count: int = 0
var speed_type: float
var _tween: Tween
var texts: Array[String] = [
	"Thank you, scarecrow, for helping us!",
	"You’re like a son to us!",
	"<3",
	"Huh? What’s this?",
	"Oh no! Scarecrow, save us...",
	"We’ve got your parents!",
	"If you want to save them, bring us the 3 bottles of ectoplasm that were taken from us ><"
]

func _ready() -> void:
	note.visible = false
	speed_type = _speed_type


func type_text(text: String) -> void:
	_last_character_count = 0
	
	text_label.text = text
	text_label.visible_characters = 0
	
	_tween = create_tween()
	
	_tween.tween_method(
		character_type,
		0, 
		text.length(),
		speed_type
	)
	
	await _tween.finished


func character_type(value: int) -> void:
	var current_count: int = value
	
	text_label.visible_characters = current_count
	
	if current_count > _last_character_count:
		type_sfx.play()
		_last_character_count = current_count


func start_cutscene() -> void:
	await get_tree().create_timer(1.0).timeout
	await type_text(texts[0])
	await get_tree().create_timer(1.0).timeout
	await type_text(texts[1])
	await get_tree().create_timer(1.0).timeout
	await type_text(texts[2])
	await get_tree().create_timer(1.0).timeout
	await type_text(texts[3])
	await get_tree().create_timer(1.0).timeout
	cutscene_animation.play("start_ufo")
	await cutscene_animation.animation_finished
	cutscene_animation.play("abduction")
	await type_text(texts[4])
	await get_tree().create_timer(1.0).timeout
	cutscene_animation.play("ufo_away")
	await cutscene_animation.animation_finished
	cutscene_animation.play("note")
	await cutscene_animation.animation_finished
	note.visible = true
	await type_text(texts[5])
	await get_tree().create_timer(1.0).timeout
	await type_text(texts[6])
	await get_tree().create_timer(2.0).timeout
	start_game_request.emit()
