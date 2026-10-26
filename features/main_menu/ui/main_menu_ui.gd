class_name MainMenuUI extends PanelContainer

signal start_game_requested
signal setting_requested
signal quit_game_requested

@onready var start_game_button: Button = %StartGameButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_game_button.pressed.connect(start_game_requested.emit)
	settings_button.pressed.connect(setting_requested.emit)
	quit_button.pressed.connect(quit_game_requested.emit)
