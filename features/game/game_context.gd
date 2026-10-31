class_name GameContext extends Node

signal main_menu_requested
signal new_game_requested

enum SubContext {
	MAP,
	LEVEL,
	RESULT_GAME,
}

enum Mission {
	MISSION_1,
	MISSION_2,
	MISSION_3,
}

const MAP: PackedScene = preload("uid://dtwt38spt642a")
const LEVEL: PackedScene = preload("uid://cfbsrft6edo7s")
const RESULT_GAME: PackedScene = preload("uid://38x7bj2bg4q0")

var _current_subcontext: SubContext
var _current_subcontext_node: Node
var _game_state: GameState
var _debug: Debug
var _music_player: MusicPlayer
var _sfx_player: SFXPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker
var _current_mission: Mission =Mission.MISSION_1

@onready var exit_game_button: Button = %ExitGameButton
@onready var map_button: Button = %MapButton


func build() -> void:
	_game_state = GameState.new()


func bind_dependencies(
		debug: Debug,
		music_player: MusicPlayer,
		sfx_player: SFXPlayer,
		input_handler: InputHandler,
		input_blocker: InputBlocker,
		) -> void:
	_debug = debug
	_music_player = music_player
	_sfx_player = sfx_player
	_input_handler = input_handler
	_input_blocker = input_blocker


func setup() -> void:
	map_button.pressed.connect(mount_map)
	exit_game_button.pressed.connect(main_menu_requested.emit)
	_game_state.game_state_changed.connect(game_state_changed)
	
	build_game_state()
	mount_map()


func mount_map() -> void:
	demount()
	
	_current_subcontext = SubContext.MAP
	_current_subcontext_node = MAP.instantiate()
	var map_context: MapContext = _current_subcontext_node as MapContext
	
	if not map_context:
		_debug.error("Map context not found", self.name)
		return
	
	add_child(map_context)
	map_context.name = "MapContext"
	map_context.build()
	map_context.bind_dependencies(_debug, _music_player, _input_handler, _input_blocker, _game_state)
	map_context.setup()
	
	map_context.mount_level_requested.connect(mount_level)
	_game_state.change_state(GameState.State.ON_MAP)


func mount_level() -> void:
	demount()
	
	_current_subcontext = SubContext.LEVEL
	_current_subcontext_node = LEVEL.instantiate()
	var level_context: LevelContext = _current_subcontext_node as LevelContext
	
	if not level_context:
		_debug.error("Map context not found", self.name)
		return
	
	add_child(level_context)
	level_context.name = "LevelContext"
	level_context.build()
	level_context.bind_dependencies(_debug,_music_player, _sfx_player, _input_handler, _input_blocker, _game_state)
	level_context.setup()
	
	level_context.main_menu_requested.connect(main_menu_requested.emit)
	level_context.new_game_requested.connect(new_game_requested.emit)
	level_context.result_game_requested.connect(mount_result)
	
	_game_state.change_state(GameState.State.ON_LEVEL)


func mount_result() -> void:
	var level_context: LevelContext = _current_subcontext_node as LevelContext
	var game_result: Dictionary = level_context.get_game_stats()
	
	demount()
	
	_current_subcontext = SubContext.RESULT_GAME
	_current_subcontext_node = RESULT_GAME.instantiate()
	
	var result_game_context: ResultGame = _current_subcontext_node as ResultGame
	
	if not level_context:
		_debug.error("Result context not found", self.name)
		return
	
	add_child(result_game_context)
	result_game_context.build(game_result["score"], game_result["ectoplasm"])
	result_game_context.bind_dependencies()
	result_game_context.setup()
	
	_game_state.change_state(GameState.State.RESULT)
	_game_state.change_mission(_current_mission + 1)
	#if _game_state.available_missions.size() <= _current_mission + 1:
		#_game_state.change_mission(_current_mission + 1)
	#else:
		#return
	
	result_game_context.next_level_requested.connect(mount_level)



func demount() -> void:
	if _current_subcontext_node:
		_current_subcontext_node.queue_free()
	
	_music_player.stop_music()


func game_state_changed(new_state: GameState.State) -> void:
	_debug.debug_log("Game state changed: %s" % str(GameState.State.keys()[new_state]), self.name)


func build_game_state() -> void:
	_game_state.available_missions = []
	
	var mission_1: MissionData = MissionData.new(
		"Level 1",
		"Cansas, O'Conner's old ferm",
		"Find out who kidnapped the old people. Rumor has it that an old farmer out west knows something.",
		"uid://k5slcdcswnta",
	)
	_game_state.available_missions.append(mission_1)
	var mission_2: MissionData = MissionData.new(
		"Level 2",
		"Nevada, Area 15",
		"Find out who kidnapped the old people. Rumor has it that an old farmer out west knows something.",
		"uid://cqbk2amnbae7n",
	)
	_game_state.available_missions.append(mission_2)
	var mission_3: MissionData = MissionData.new(
		"Level 3",
		"Nevada, Area 15",
		"Find out who kidnapped the old people. Rumor has it that an old farmer out west knows something.",
		"uid://k5slcdcswnta",
	)
	_game_state.available_missions.append(mission_3)
	
	_game_state.change_mission(_current_mission)
