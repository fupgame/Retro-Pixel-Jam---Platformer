class_name MainMenuContext extends Node

signal start_game_requested

var _debug: Debug
var _music_player: MusicPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker

@onready var start_game_button: Button = %StartGameButton



func build() -> void:
	pass


func bind_dependencies(
			debug: Debug,
			music_player: MusicPlayer,
			input_handler: InputHandler,
			input_blocker: InputBlocker
			) -> void:
	_debug = debug
	_music_player = music_player
	_input_handler = input_handler
	_input_blocker = input_blocker


func setup() -> void:
	start_game_button.pressed.connect(start_game_requested.emit)


func _process(delta: float) -> void:
	if _input_handler.is_just_pressed("escape"):
		get_tree().quit()
