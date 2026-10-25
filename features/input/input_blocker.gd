class_name InputBlocker extends Node

enum GROUP_ID { BLOCK_GAMEPLAY, BLOCK_UI }

const BLOCK_GROUPS: Dictionary = {
	GROUP_ID.BLOCK_GAMEPLAY: [
		&"move_left",
		&"move_right",
		&"move_up",
		&"move_down",
		&"jump",
		&"attack",
		&"interact",
		&"test",
	],
	GROUP_ID.BLOCK_UI: [
		&"ui_accept",
		&"ui_cancel",
	],
}

var _blokers: Dictionary = {}


func block(blocker: StringName, group: GROUP_ID) -> void:
	_blokers[blocker] = BLOCK_GROUPS[group]


func unblock(blocker: StringName) -> void:
	_blokers.erase(blocker)


func is_blocked(action: StringName) -> bool:
	for actions: Array in _blokers.values():
		if action in actions:
			return true
	
	return false
	
	
