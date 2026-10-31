@tool
class_name Collectable extends Node2D

signal collected (collect_type: ItemType)

enum ItemType{
	COIN,
	CARROT,
	ECTOPLASM,
}


#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
#@onready var collect_sfx: AudioStreamPlayer2D = $CollectSFX
@onready var collected_area: Area2D = $CollectedArea

var _is_collected: bool = false
var animated_sprite: AnimatedSprite2D
var collect_sfx: AudioStreamPlayer2D
var particles: GPUParticles2D

@export var type: ItemType:
	set(value):
		type = value
		update_data()
@export var carrot_frames: SpriteFrames
@export var carrot_sfx: AudioStreamWAV
@export var coin_frames: SpriteFrames
@export var coin_sfx: AudioStreamWAV
@export var ectoplasm_frames: SpriteFrames
@export var ectoplasm_sfx: AudioStreamWAV


func _ready() -> void:
	update_data()


func update_data() -> void:
	animated_sprite = get_node_or_null("AnimatedSprite")
	collect_sfx = get_node_or_null("CollectSFX")
	particles = get_node_or_null("GPUParticles2D")
	
	if not animated_sprite:
		return
	
	match type:
		ItemType.COIN:
			name = "Coin"
			animated_sprite.sprite_frames = coin_frames
			collect_sfx.stream = coin_sfx
			particles.emitting = false
		ItemType.CARROT:
			name = "Carrot"
			animated_sprite.sprite_frames =  carrot_frames
			collect_sfx.stream = carrot_sfx
			particles.emitting = false
		ItemType.ECTOPLASM:
			name = "Ectoplasm"
			animated_sprite.sprite_frames = ectoplasm_frames
			collect_sfx.stream = ectoplasm_sfx
			particles.emitting = true
			
	animated_sprite.play("idle")


func collect() -> void:
	if _is_collected:
		return
	
	_is_collected = true
	
	collected.emit(type)
	
	collect_sfx.play()
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position - Vector2(0.0, 15.0), 0.5)
	tween.parallel()
	tween.tween_property(self, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)
	


func _on_collected_area_body_entered(body: Node2D) -> void:
	collect()
