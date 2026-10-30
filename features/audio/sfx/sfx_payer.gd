class_name SFXPlayer extends AudioStreamPlayer3D

var _debug: Debug
var _bus_index: int


func build() -> void:
	bus = "SFX"
	_bus_index = AudioServer.get_bus_index(bus)


func bind_dependencies(debug: Debug) -> void:
	_debug = debug


func sfx_play(sfx_audio: AudioStream) -> void:
	
	stream = sfx_audio
	pitch_scale = randf_range(0.8, 1.2)
	
	play()


func change_volume_db(value: float) -> void:
	if value == -25:
		AudioServer.set_bus_mute(_bus_index, true)
	else:
		AudioServer.set_bus_mute(_bus_index, false)
		AudioServer.set_bus_volume_db(_bus_index, value)
