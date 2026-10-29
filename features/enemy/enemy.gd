class_name Enemy extends CharacterBody2D

enum State {
	IDLE,
	PATROL,
	ATTACK,
	HURT,
	DEAD,
}
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var timer_attack: Timer = $TimerAttack
@onready var hurt_box: Area2D = $HurtBox
@onready var hit_box: Area2D = $HitBox

@export var animated_sprite: AnimatedSprite2D
@export var _max_speed:float = 60.0
@export var _gravity: float = 980.0
@export var _point_a: Marker2D
@export var _point_b: Marker2D
@export var _knockback_force: float = 150.0
@export var _attack_cooldown: float = 1.0

var _can_attack: bool = true
var _current_state: State = State.IDLE
var _max_health:int = 20
var _is_died: bool = false
# Srevices
var _debug: Debug
var _sfx_player: SFXPlayer
var _direction: float = 1.0


func bild() -> void:
	pass


func bind_dependencies(
		debug: Debug,
		sfx_player: SFXPlayer,
		) -> void:
	_debug = debug
	_sfx_player = sfx_player


func setup() -> void:
	deactived_hit_box()
	hurt_box.area_entered.connect(take_damage)
	timer_attack.wait_time = _attack_cooldown
	change_state(State.PATROL)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = _gravity * delta
	
	if player_detector.is_colliding():
		var player: Node2D = player_detector.get_collider()
		
		if player.global_position.x > global_position.x:
			_direction = 1.0
		else:
			_direction = -1.0
		
		if _current_state == State.PATROL and _can_attack:
			change_state(State.ATTACK)
	
	if _current_state == State.PATROL:
		velocity.x = _max_speed * _direction
	elif _current_state ==  State.HURT:
		velocity.x = -_direction * _knockback_force
	elif _current_state == State.ATTACK:
		velocity.x = 0.0
	
	if not _current_state == State.DEAD:
		move_and_slide()
	
	if _current_state == State.PATROL:
		if is_on_wall() or reached_patrol_point():
			_direction *= -1
	
	change_face_side()

func reached_patrol_point() -> bool:
	var target_x: float
	if _direction > 0:
		target_x = _point_b.global_position.x
	else:
		target_x = _point_a.global_position.x
	
	return absf(global_position.x - target_x) < 2.0


func change_face_side() -> void:
	if _current_state == State.HURT:
		return
		
	if velocity.x > 0:
		animated_sprite.flip_h = false
		if hit_box.scale.x == -1:
			hit_box.scale.x = 1
			player_detector.scale.x = 1
	if velocity.x < 0:
		animated_sprite.flip_h = true
		if hit_box.scale.x == 1:
			hit_box.scale.x = -1
			player_detector.scale.x = -1


func take_damage(_area: Area2D) -> void:
	if _current_state == State.DEAD:
		return
	
	_max_health = maxi(_max_health - 10, 0)
	change_state(State.HURT)
	await  animated_sprite.animation_finished
	change_state(State.PATROL)

	
	if _max_health == 0:
		change_state(State.DEAD)


func change_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	
	_current_state = new_state
	animation_controller()


func animation_controller() -> void:
	if _is_died:
		return
	
	match _current_state:
		State.IDLE:
			animated_sprite.play("idle")
		State.PATROL:
			animated_sprite.play("run")
		State.ATTACK:
			actived_hit_box()
			animated_sprite.play("attack")
			_can_attack = false
			
			await animated_sprite.animation_finished
			
			if not _current_state == State.ATTACK:
				deactived_hit_box()
				return
			
			deactived_hit_box()
			
			if _current_state == State.ATTACK:
				if not player_detector.is_colliding():
					change_state(State.PATROL)
				
				timer_attack.start()
				await  timer_attack.timeout
				
				_can_attack = true
					
				if player_detector.is_colliding() and _current_state == State.PATROL:
					change_state(State.ATTACK)
				elif _current_state == State.ATTACK:
					change_state(State.PATROL)
					
		State.HURT:
			animated_sprite.play("hurt")
		State.DEAD:
			animated_sprite.play("dead")
			await animated_sprite.animation_finished 
			_is_died = true


func actived_hit_box() -> void:
	var collision: CollisionShape2D = hit_box.get_child(0)
	collision.disabled = false
	hit_box.monitorable = true
	hit_box.monitoring = true


func deactived_hit_box() -> void:
	var collision: CollisionShape2D = hit_box.get_child(0)
	collision.disabled = true
	hit_box.monitorable = false
	hit_box.monitoring = false
