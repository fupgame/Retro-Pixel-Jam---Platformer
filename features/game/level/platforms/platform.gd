class_name Platform extends AnimatableBody2D

enum  Direction {
	HORIZONTAL,
	VERTICAL,
}

@export var _max_lenght: float = 100.0
@export var _direction: Direction
@export var _duration: float = 2.0
var _start_position: Vector2

var tween: Tween


func _ready() -> void:
	_start_position = position
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", get_target_position(), _duration)
	tween.tween_property(self, "position", _start_position, _duration)


func get_target_position() -> Vector2:
	var target_position: Vector2 = position
	
	match _direction:
		Direction.HORIZONTAL:
			target_position.x += _max_lenght
		Direction.VERTICAL:
			target_position.y += _max_lenght
	
	return target_position
