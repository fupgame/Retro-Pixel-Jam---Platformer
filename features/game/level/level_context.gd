class_name LevelContext extends Node2D

signal main_menu_requested
signal new_game_requested
signal result_game_requested

const PLAYER: PackedScene = preload("uid://cuf2n2r328ra8")
const UI_HUD: PackedScene = preload("uid://b2d0kmpto3638")
const MENU_PAUSED: PackedScene = preload("uid://lw3bhkcwfc02")

var _level: Level
var _player: Player
var _ui_hud: HUD
var _menu_paused: MenuPaused
var _enemies: Array[Enemy]
# Dependencies
var _game_state: GameState
var _debug: Debug
var _music_player: MusicPlayer
var _sfx_player: SFXPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker
var _mission: MissionData
var _score: int = 0
var _ectoplasm: int = 0


func build() -> void:
	_player = PLAYER.instantiate() as Player


func bind_dependencies(
		debug: Debug,
		music_player: MusicPlayer,
		sfx_player: SFXPlayer,
		input_handler: InputHandler,
		input_blocker: InputBlocker ,
		game_state: GameState) -> void:
	_debug = debug
	_game_state = game_state
	_music_player = music_player
	_sfx_player = sfx_player
	_input_handler = input_handler
	_input_blocker = input_blocker


func setup() -> void:
	mount_level()
	mount_ui_hud()
	mount_menu_paused()
	spawn_player()
	bind_enemies()
	connect_collectables()
	connect_enemies()


func mount_level() -> void:
	if _level:
		_level.queue_free()
		
	_mission = _game_state.available_missions[_game_state.current_mission_index]
	var _level_scene: PackedScene = load(_mission.level_scene_path)
	_level = _level_scene.instantiate() as Level
	add_child(_level)
	_level.name = _mission.name
	_level.player_on_finish.connect(result_game_requested.emit)


func mount_ui_hud() -> void:
	if _ui_hud:
		_ui_hud.queue_free()
	
	_ui_hud = UI_HUD.instantiate()
	
	add_child(_ui_hud)


func mount_menu_paused() -> void:
	if _menu_paused:
		_menu_paused.queue_free()
	
	_menu_paused = MENU_PAUSED.instantiate()
	
	add_child(_menu_paused)
	_menu_paused.hide()
	_menu_paused.hide_puase_menu_requested.connect(toggle_pused_menu)
	_menu_paused.main_menu_requested.connect(main_menu_requested.emit)
	_menu_paused.new_game_requested.connect(new_game_requested.emit)


func spawn_player() -> void:
	add_child(_player)
	_player.name = "Player"
	_player.global_position = _level.player_spawn_position.global_position
	_player.bild()
	_player.bind_dependencies(_debug, _sfx_player, _input_handler, _input_blocker)
	_player.setup()

	_player.damage_taked.connect(_ui_hud.health_bar.health_down)
	_player.heal_taked.connect(_ui_hud.health_bar.health_up)
	_player.pause_requested.connect(toggle_pused_menu)
	_player.game_over_request.connect(toggle_pused_menu)


func toggle_pused_menu(game_over: bool = false) -> void:
	if _menu_paused.visible:
		_menu_paused.hide()
		_level.process_mode = Node.PROCESS_MODE_INHERIT
		_player.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		_menu_paused.show_menu(game_over)
		_level.process_mode = Node.PROCESS_MODE_DISABLED
		_player.process_mode = Node.PROCESS_MODE_DISABLED



func bind_enemies() -> void:
	if _level.enemies.is_empty():
		return
	
	for enemy in _level.enemies:
		enemy.bild()
		enemy.bind_dependencies(_debug, _sfx_player)
		enemy.setup()


func connect_collectables() -> void:
	var collectables: Array[Collectable] = _level.collectables
	
	if collectables.is_empty():
		return
	
	for collectable in collectables:
		collectable.collected.connect(collect_requested)


func connect_enemies() -> void:
	var enemies: Array[Enemy] = _level.enemies
	
	if enemies.is_empty():
		return
	
	for enemy in enemies:
		enemy.enemy_died.connect(func() -> void:
			_score += 10
			_ui_hud.score_bar.score_update(_score) )


func collect_requested(type: Collectable.ItemType) -> void:
	match type:
		Collectable.ItemType.COIN:
			_score += 1
			_ui_hud.score_bar.score_update(_score)
		Collectable.ItemType.CARROT:
			_player.heal()
		Collectable.ItemType.ECTOPLASM:
			_ectoplasm += 1
			_ui_hud._ectoplasma_bar.add_ectoplasm(_ectoplasm)


func get_game_stats() -> Dictionary:
	var stats: Dictionary = {
		"score": _score,
		"ectoplasm": _ectoplasm,
	}
	
	return stats
