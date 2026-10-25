class_name SFXPlayer extends AudioStreamPlayer3D

var _debug: Debug


func bind_dependencies(debug: Debug) -> void:
	_debug = debug


func sfx_play(sfx_audio: AudioStream) -> void:
	
	stream = sfx_audio
	pitch_scale = randf_range(0.8, 1.2)
	
	play()
