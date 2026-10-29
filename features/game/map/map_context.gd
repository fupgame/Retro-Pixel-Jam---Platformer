class_name MapContext extends Node2D

signal mount_level_requested

@onready var timer: Timer = $Timer
@onready var misson_name: Label = %"Misson Name"
@onready var place_name: Label = %PlaceName
@onready var target_description: Label = %TargetDescription
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _debug: Debug
var _music_player: MusicPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker
var _game_state: GameState


func build() -> void:
	pass


func bind_dependencies(
		debug: Debug,
		music_player: MusicPlayer,
		input_handler: InputHandler,
		input_blocker: InputBlocker,
		game_state: GameState
		) -> void:
	_debug = debug
	_music_player = music_player
	_input_handler = input_handler
	_input_blocker = input_blocker
	_game_state = game_state


func setup() -> void:
	var mission: MissionData = _game_state.available_missions[_game_state.current_mission_index]
	misson_name.text = mission.name
	place_name.text = mission.place
	target_description.text = mission.target_description
	
	timer.start(1)
	await  timer.timeout
	move_to_point(_game_state.current_mission_index)
	timer.start(5)
	timer.timeout.connect(mount_level_requested.emit)


func move_to_point(index: int) -> void:
	match index:
		0:
			animation_player.play("RESET")
		1:
			animation_player.play("move_to_point_2")
		2:
			animation_player.play("move_to_point_3")


func _process(_delta: float) -> void:
	if _input_handler.is_just_pressed("ui_accept") or _input_handler.is_just_pressed("ui_select"):
		mount_level_requested.emit()
