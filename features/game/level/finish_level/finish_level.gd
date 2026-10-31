class_name FinishLevel extends Area2D

signal player_enter_on_finish


#func _ready() -> void:
	#body_entered.connect(player_enter_on_finish.emit)


func _on_body_entered(_body: Node2D) -> void:
	player_enter_on_finish.emit()
