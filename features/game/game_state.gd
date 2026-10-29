class_name GameState extends Resource

signal game_state_changed (new_state: State)

enum State {
	START_GAME,
	ON_MAP,
	ON_LEVEL,
	RESULT,
	GAME_OVER,
	PAUSED,
}

var _current_state: State = State.START_GAME
var _score: int = 0
var score: int:
	get():
		return _score
var available_missions: Array[MissionData]
var _current_mission_index: int = 0
var _last_mission_index: int = 0
var current_mission_index: int:
	get():
		return _current_mission_index


func change_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	
	_current_state = new_state
	game_state_changed.emit(_current_state)


func change_mission(index: int) -> void:
	if _current_mission_index == index:
		return
	
	_last_mission_index = _current_mission_index
	_current_mission_index = index
