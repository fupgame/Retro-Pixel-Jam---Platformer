class_name LevelContext extends Node2D

const PLAYER: PackedScene = preload("uid://cuf2n2r328ra8")

var _level: Level
var _player: Player
var _enemies: Array[Enemy]
# Dependencies
var _game_state: GameState
var _debug: Debug
var _sfx_player: SFXPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker
var _mission: MissionData

func build() -> void:
	_player = PLAYER.instantiate() as Player

func bind_dependencies(
		debug: Debug,
		sfx_player: SFXPlayer,
		input_handler: InputHandler,
		input_blocker: InputBlocker ,
		game_state: GameState) -> void:
	_debug = debug
	_game_state = game_state
	_sfx_player = sfx_player
	_input_handler = input_handler
	_input_blocker = input_blocker


func setup() -> void:
	mount_level()
	spawn_player()
	bind_enemies()


func mount_level() -> void:
	if _level:
		_level.queue_free()
		
	_mission = _game_state.available_missions[_game_state.current_mission_index]
	var _level_scene: PackedScene = load(_mission.level_scene_path)
	_level = _level_scene.instantiate() as Level
	add_child(_level)
	_level.name = _mission.name


func spawn_player() -> void:
	add_child(_player)
	_player.name = "Player"
	_player.global_position = _level.player_spawn_position.global_position
	_player.bild()
	_player.bind_dependencies(_debug, _sfx_player, _input_handler, _input_blocker)
	_player.setup()


func bind_enemies() -> void:
	if _level.enemies.is_empty():
		return
	
	for enemy in _level.enemies:
		enemy.bild()
		enemy.bind_dependencies(_debug, _sfx_player)
		enemy.setup()
