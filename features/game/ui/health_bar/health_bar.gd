class_name HealthBar extends Control

@onready var icon_container: HBoxContainer = $IconContainer
@onready var health_bar_sfx: AudioStreamPlayer = $HealthBarSFX

#var icons: Array[HealthIcon]
var health_count: int = 0
var health_scene: PackedScene = preload("uid://cxeyhu26fnohi")

@export var health_up_sfx: AudioStreamWAV
@export var health_down_sfx: AudioStreamWAV


func health_down() -> void:
	var icons: Array[Node] = icon_container.get_children()
	var last_fill_icon: HealthIcon = icons[0]
	health_bar_sfx.stream = health_down_sfx

	for i in range(icons.size() - 1, -1, -1):
		var health_icon: HealthIcon = icons[i]
		
		if health_icon.state == HealthIcon.State.FILL:
			health_icon.change_state(HealthIcon.State.EMPTY)
			health_bar_sfx.play()
			return
	


func health_up() -> void:
	var icons: Array[Node] = icon_container.get_children()

	for icon in icons:
		var health_icon: HealthIcon = icon as HealthIcon
		
		if health_icon.state == HealthIcon.State.FILL:
			continue
			
		health_icon.change_state(HealthIcon.State.FILL)
		return
	


func upgrade_health() -> void:
	var new_health: HealthIcon = health_scene.instantiate() as HealthIcon
	var count: int = icon_container.get_children().size()
	var last_icon: HealthIcon = icon_container.get_child(count - 1)
	health_bar_sfx.stream = health_up_sfx
	
	new_health.offset_transform_scale = Vector2.ZERO
	icon_container.add_child(new_health)
	
	if last_icon.state == HealthIcon.State.EMPTY:
		icon_container.move_child(new_health, count - 1)
		
	new_health.appearance_icon()
	health_bar_sfx.play()
