class_name EctoplasmaBar extends Control

@onready var icon_container: HBoxContainer = $IconContainer

var _quantity_ectoplasm: int = 0
var _ectoplasm_icon_scene: PackedScene = preload("uid://dw7miu8ef1bl4")


func add_ectoplasm(value: int) -> void:
	_quantity_ectoplasm = value
	update_icons()


func update_icons() -> void:
	if _quantity_ectoplasm == 0:
		return
	
	if not icon_container.get_children().is_empty():
		for icon in icon_container.get_children():
			icon.queue_free()
	
	for i in _quantity_ectoplasm:
		var new_icon: TextureRect = _ectoplasm_icon_scene.instantiate()
		icon_container.add_child(new_icon)
