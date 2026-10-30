class_name MenuPaused extends CanvasLayer

signal hide_puase_menu_requested
signal main_menu_requested

@onready var continue_button: Button = %ContinueButton
@onready var exit_button: Button = %ExitButton
@onready var pause_audio_player: AudioStreamPlayer = $PauseAudioPlayer


func _ready() -> void:
	continue_button.pressed.connect(hide_puase_menu_requested.emit)
	exit_button.pressed.connect(main_menu_requested.emit)
