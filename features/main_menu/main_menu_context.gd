class_name MainMenuContext extends Node

signal start_game_requested
signal quit_game_requested

const MAIN_MENU_MUSIC: AudioStream = preload("uid://dnnqcmyta17gq")

var _debug: Debug
var _music_player: MusicPlayer
var _sfx_player: SFXPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker

@onready var main_menu_ui: MainMenuUI = %MainMenuUi
@onready var setting_ui: SettingUI = %SettingUI


func build() -> void:
	pass


func bind_dependencies(
			debug: Debug,
			music_player: MusicPlayer,
			sfx_player: SFXPlayer,
			input_handler: InputHandler,
			input_blocker: InputBlocker
			) -> void:
	_debug = debug
	_music_player = music_player
	_sfx_player = sfx_player
	_input_handler = input_handler
	_input_blocker = input_blocker


func setup() -> void:
	setting_ui.hide()
	
	main_menu_ui.start_game_requested.connect(start_game_requested.emit)
	main_menu_ui.setting_requested.connect(enter_setting_menu_requested)
	main_menu_ui.quit_game_requested.connect(quit_game_requested.emit)
	
	setting_ui.music_volume_change_requested.connect(handle_music_volume_value)
	setting_ui.sfx_volume_change_requested.connect(handle_sfx_volume_value)
	setting_ui.full_screen_change_requested.connect(handle_fullscreen_checkbox_value)
	setting_ui.back_to_main_menu_requested.connect(exit_setting_menu_requested)
	_music_player.play_music(MAIN_MENU_MUSIC)


func enter_setting_menu_requested() -> void:
	main_menu_ui.hide()
	setting_ui.show()


func exit_setting_menu_requested() -> void:
	setting_ui.hide()
	main_menu_ui.show()


func handle_music_volume_value(value: float) -> void:
	_music_player.change_volume_db(value)


func handle_sfx_volume_value(value: float) -> void:
	_sfx_player.change_volume_db(value)


func handle_fullscreen_checkbox_value(value: bool) -> void:
	_debug.debug_log("Fullscreen changed: ", str(value))
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
