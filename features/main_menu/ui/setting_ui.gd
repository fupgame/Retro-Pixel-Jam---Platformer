class_name SettingUI extends PanelContainer

signal music_volume_change_requested (value: float)
signal sfx_volume_change_requested (value: float)
signal full_screen_change_requested (value: bool)
signal back_to_main_menu_requested

@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = %SFXVolumeSlider
@onready var full_screen_checkbox: CheckBox = %FullScreenCheckBox
@onready var back_button: Button = %BackButton


func _ready() -> void:
	music_volume_slider.value_changed.connect(music_volume_changed)
	sfx_volume_slider.value_changed.connect(sfx_volume_changed)
	full_screen_checkbox.toggled.connect(full_screen_changed)
	back_button.pressed.connect(back_to_main_menu_requested.emit)


func music_volume_changed(value: float) -> void:
	music_volume_change_requested.emit(value)


func sfx_volume_changed(value: float) -> void:
	sfx_volume_change_requested.emit(value)


func full_screen_changed(value: bool) -> void:
	full_screen_change_requested.emit(value)
