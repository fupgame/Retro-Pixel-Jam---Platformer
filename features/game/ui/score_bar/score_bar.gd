class_name ScoreBar extends Control

@onready var score_label: Label = %ScoreLabel

var _score: int = 0


func score_update(value: int) -> void:
	_score = value
	score_label.text = str(_score)
