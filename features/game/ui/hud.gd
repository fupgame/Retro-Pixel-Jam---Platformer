class_name HUD extends CanvasLayer

@onready var _health_bar: HealthBar = %HealthBar
@onready var _score_bar: ScoreBar = %ScoreBar
@onready var _ectoplasma_bar: EctoplasmaBar = %EctoplasmaBar

var health_bar: HealthBar:
	get():
		return _health_bar
var score_bar: ScoreBar:
	get():
		return _score_bar
var ectoplasma_bar: EctoplasmaBar:
	get():
		return _ectoplasma_bar
