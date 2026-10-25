class_name GameContext extends Node

signal main_menu_requested

@onready var exit_game_button: Button = %ExitGameButton


func build() -> void:
	pass


func bind_dependencies() -> void:
	pass


func setup() -> void:
	exit_game_button.pressed.connect(main_menu_requested.emit)
