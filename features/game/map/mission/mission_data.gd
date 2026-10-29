class_name MissionData extends Resource

@export var name: String
@export var place: String
@export var target_description: String
@export var level_scene_path: String


func _init(
		_name: String,
		_place: String,
		_target_description: String,
		_level_path: String,
		) -> void:
	name = _name
	place = _place
	target_description = _target_description
	level_scene_path = _level_path
