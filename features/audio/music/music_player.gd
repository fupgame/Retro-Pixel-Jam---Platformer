class_name MusicPlayer extends AudioStreamPlayer

var _debug: Debug
var _bus_index: int


func build() -> void:
	bus = "Music"
	_bus_index = AudioServer.get_bus_index(bus)
	


func bind_dependencies(debug: Debug) -> void:
	_debug = debug


func play_music(audio: AudioStream) -> void:
	stop_music()
	
	# TODO: Сделать плавное затухание и наростание
	# TODO: Сделать возмодность устанавливать громкость в аргументе
	
	stream = audio
	play()


func stop_music() -> void:
	if stream:
		stream = null
	
	stop()


func change_volume_db(value: float) -> void:
	if value == -10:
		AudioServer.set_bus_mute(_bus_index, true)
	else:
		AudioServer.set_bus_mute(_bus_index, false)
		AudioServer.set_bus_volume_db(_bus_index, value)
