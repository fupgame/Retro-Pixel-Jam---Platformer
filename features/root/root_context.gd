class_name RootContext extends Node

enum SubCOntext {
	MAIN_MENU,
	GAME,
}

const MAIN_MENU_CONTEXT_SCENE: PackedScene = preload("uid://c6s7m10an26mg")
const GAME_CONTEXT_SCENE: PackedScene = preload("uid://cyrxtkpuid2rf")

var _current_subcontext: SubCOntext
var _current_subcontext_node: Node
var _debug: Debug
var _music_player: MusicPlayer
var _sfx_player: SFXPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker


func _ready() -> void:
	build()
	bind_dependencies()
	setup()


func build() -> void:
	_debug = Debug.new()
	_debug.name = "Debug"
	add_child(_debug)
	
	_music_player = MusicPlayer.new()
	_music_player.build()
	_music_player.name = "MusicPlayer"
	add_child(_music_player)
	
	_sfx_player = SFXPlayer.new()
	_sfx_player.build()
	_sfx_player.name = "SFXPlayer"
	add_child(_sfx_player)
	
	_input_handler = InputHandler.new()
	_input_handler.name = "InputHandler"
	add_child(_input_handler)
	
	_input_blocker = InputBlocker.new()
	_input_blocker.name = "InputBlocker"
	add_child(_input_blocker)


func bind_dependencies() -> void:
	_input_handler.bind_dependencies(_debug, _input_blocker)
	_music_player.bind_dependencies(_debug)
	_sfx_player.bind_dependencies(_debug)


func setup() -> void:
	mount_main_menu()


func mount_main_menu() -> void:
	if _current_subcontext_node:
		_current_subcontext_node.queue_free()
	
	_current_subcontext = SubCOntext.MAIN_MENU
	_current_subcontext_node = MAIN_MENU_CONTEXT_SCENE.instantiate()
	var main_menu_context: MainMenuContext = _current_subcontext_node as MainMenuContext
	if not main_menu_context:
		_debug.error("Main menu context not found", self.name)
		return
	
	add_child(main_menu_context)
	main_menu_context.name = "MainMenuContext"
	main_menu_context.build()
	main_menu_context.bind_dependencies(_debug, _music_player, _sfx_player, _input_handler, _input_blocker)
	main_menu_context.setup()
	
	main_menu_context.start_game_requested.connect(mount_game)
	main_menu_context.quit_game_requested.connect(exit_game)


func mount_game() -> void:
	if _current_subcontext_node:
		_current_subcontext_node.queue_free()
	
	_current_subcontext = SubCOntext.GAME
	_current_subcontext_node = GAME_CONTEXT_SCENE.instantiate()
	var game_context: GameContext = _current_subcontext_node as GameContext
	if not game_context:
		push_error("[ROOT] Game context not found")
		return
	
	add_child(game_context)
	game_context.name = "GameContext"
	game_context.build()
	game_context.bind_dependencies()
	game_context.setup()
	
	game_context.main_menu_requested.connect(mount_main_menu)


func exit_game() -> void:
	get_tree().quit()
