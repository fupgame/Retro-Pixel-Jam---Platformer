class_name MusicPlayer extends AudioStreamPlayer

var _debug: Debug


func bind_dependencies(debug: Debug) -> void:
	_debug = debug


func play_music(audio: AudioStream) -> void:
	if stream:
		stream = null
	
	# TODO: Сделать плавное затухание и наростание
	# TODO: Сделать возмодность устанавливать громкость в аргументе
	
	stream = audio
	play()
