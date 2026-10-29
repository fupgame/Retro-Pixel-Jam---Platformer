class_name Level extends Node2D

@export var _collectables: Array[Collectable]
@export var _spawn_points: Array[Marker2D]
@export var _player_spawn_position: Marker2D
@export var _enemies: Array[Enemy]

var player_spawn_position: Marker2D:
	get():
		return _player_spawn_position


var enemies: Array[Enemy]:
	get():
		return _enemies
