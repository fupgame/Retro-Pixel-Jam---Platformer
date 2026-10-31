class_name MenuPaused extends CanvasLayer

signal hide_puase_menu_requested
signal main_menu_requested
signal new_game_requested

@onready var title_label: Label = %TitleLabel
@onready var new_game_button: Button = %NewGameButton
@onready var continue_button: Button = %ContinueButton
@onready var exit_button: Button = %ExitButton
@onready var pause_audio_player: AudioStreamPlayer = $PauseAudioPlayer
@onready var game_over_sfx: AudioStreamPlayer = $GameOverSFX


func _ready() -> void:
	new_game_button.pressed.connect(new_game_requested.emit)
	continue_button.pressed.connect(hide_puase_menu_requested.emit)
	exit_button.pressed.connect(main_menu_requested.emit)


func show_menu(game_over: bool = false) -> void:
	if game_over:
		title_label.text = "Game Over"
		new_game_button.visible = true
		continue_button.visible = false
		game_over_sfx.play()
	else:
		title_label.text = "Paused"
		new_game_button.visible = false
		continue_button.visible = true
	
	show()
