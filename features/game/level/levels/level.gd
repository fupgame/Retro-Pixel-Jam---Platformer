class_name Level extends Node2D

signal player_on_finish

@onready var collectables_container: Node2D = $Collectables
@onready var enemies_container: Node2D = $Enemies

@export var _player_spawn_position: Marker2D
@export var _finish_area: FinishLevel
var _enemies: Array[Enemy]
var _collectables: Array[Collectable]


func _ready() -> void:
	for child in collectables_container.get_children():
		if child is Collectable:
			_collectables.append(child)
	
	for childs in enemies_container.get_children():
		for child in childs.get_children():
			if child is Enemy:
				_enemies.append(child)
	
	if _finish_area:
		_finish_area.player_enter_on_finish.connect(player_on_finish.emit)


var player_spawn_position: Marker2D:
	get():
		return _player_spawn_position


var enemies: Array[Enemy]:
	get():
		return _enemies

var collectables: Array[Collectable]:
	get():
		return _collectables
