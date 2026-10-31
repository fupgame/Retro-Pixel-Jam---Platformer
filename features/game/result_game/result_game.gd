class_name ResultGame extends Node2D

signal next_level_requested ()

@onready var score_count: Label = %Count1
@onready var ectoplasm_count: Label = %Count2
@onready var continue_button: Button = %ContinueButton

var _score: int = 0
var _ectoplasm: int = 0
var result: Dictionary

func build(score: int, ectoplasm: int) -> void:
	_score = score
	_ectoplasm = ectoplasm


func bind_dependencies() -> void:
	pass


func setup() -> void:
	set_result()
	update_ui()
	continue_button.pressed.connect(go_next_level)


func set_result() -> void:
	result = {
		"score": _score,
		"ectoplasm": _ectoplasm
	}
	
	
func go_next_level() -> void:
	next_level_requested.emit()


func update_ui() -> void:
	score_count.text = str(_score)
	ectoplasm_count.text = str(_ectoplasm)
