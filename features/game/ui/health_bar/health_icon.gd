class_name HealthIcon extends TextureRect

enum State{
	FILL,
	EMPTY
}
@onready var explosive_particles: GPUParticles2D = $ExplosiveParticles

@export var fill_icon: AtlasTexture
@export var empty_icon: AtlasTexture

@export var _current_state: State = State.FILL
var state:State:
	get():
		return _current_state


func change_state(new_state: State) -> void:
	if new_state == _current_state:
		return
	
	_current_state = new_state
	
	# Update icon
	match _current_state:
		State.FILL:
			texture = fill_icon
		State.EMPTY:
			texture = empty_icon
	
	if explosive_particles.emitting:
		explosive_particles.emitting = false
	
	explosive_particles.emitting = true


func appearance_icon() -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "offset_transform_scale", Vector2(1.3, 1.3), 0.15).set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "offset_transform_scale", Vector2(0.8, 0.8), 0.15).set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "offset_transform_scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
