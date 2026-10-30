class_name Player extends CharacterBody2D

signal damage_taked
signal heal_taked
signal pause_requested

enum State {
	IDLE,
	RUN,
	JUMP,
	START_JUMP,
	LANDING,
	FALL,
	ATTACK,
	HURT,
	DEAD,
}

@onready var player_animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite
@onready var attack_animated_sprite: AnimatedSprite2D = $AttackAnimatedSprite
@onready var arms_animated_sprite: AnimatedSprite2D = $ArmsAnimatedSprite
@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox

@export var _max_health:int = 100
@export var _max_speed: float = 150.0
@export var _acceleration: float = 400.0
@export var _friction: float = 300.0
@export var _jump_force: float = -350.0
@export var _jump_cut: float = 0.0
@export var _jump_buffer_timer: float = 0.12
@export var _coyote_time: float = 0.25
@export var _gravity: float = 20.0
@export var _combo_window: float = 1.0
@export var _combo_frames_before_end: int = 3
@export var _hitbox_start_farme: int = 3
@export var _hitbox_end_frame: int = 5
@export var _hurt_impulse: Vector2 = Vector2(80.0, -80.0)

var _current_health: int
var _current_speed: float = 0.0
var jump_buffer_timer: float = 0.0
var coyote_time: float = 0.0
var _current_state: State = State.IDLE
var _combo_timer: float = 0.0
var _combo_queued: bool = false
var _current_attack: int = 0
var _combo_open: bool = false
# Srevices
var _debug: Debug
var _sfx_player: SFXPlayer
var _input_handler: InputHandler
var _input_blocker: InputBlocker
var _direction: Vector2


func bild() -> void:
	pass


func bind_dependencies(
		debug: Debug,
		sfx_player: SFXPlayer,
		input_handler: InputHandler,
		input_blocker: InputBlocker,
		) -> void:
	_debug = debug
	_sfx_player = sfx_player
	_input_handler = input_handler
	_input_blocker = input_blocker


func setup() -> void:
	player_animated_sprite.animation_finished.connect(animation_finished)
	hurt_box.area_entered.connect(take_damage)
	_current_speed = _max_speed
	_current_health = _max_health
	deactived_hit_box()


func _process(delta: float) -> void:
	if _input_handler.is_just_pressed("escape"):
		pause_requested.emit()


func _physics_process(delta: float) -> void:
	if _current_state == State.DEAD:
		return
	
	if _current_state == State.HURT:
		apply_gravity(delta)
		move_and_slide()
		return
	
	# Attack
	var frame_count: int = attack_animated_sprite.sprite_frames.get_frame_count("attack_01")
	var combo_start_frame: int = maxi(frame_count - _combo_frames_before_end, 0)
	
	if _current_state == State.ATTACK and _current_attack == 1:
		if not _combo_open and player_animated_sprite.frame >= combo_start_frame:
			_combo_open = true
			_combo_timer = _combo_window
	
	if _combo_open:
		_combo_timer = maxf(_combo_timer - delta, 0.0)
	
	if _input_handler.is_just_pressed("attack"):
		if _current_state == State.ATTACK:
			if _current_attack == 1 and _combo_open and _combo_timer > 0.0:
				_combo_queued = true
		else:
			start_attack(1)
	
	var frame_attcak: int = attack_animated_sprite.frame
	
	if frame_attcak >= _hitbox_start_farme and frame_attcak <= _hitbox_end_frame:
		actived_hit_box()
	else:
		deactived_hit_box()
		
	
	_direction = _input_handler.get_vector("left", "right", "up", "down").normalized()
	
	# Update timers
	if is_on_floor():
		coyote_time = _coyote_time
	else:
		coyote_time = maxf(coyote_time - delta, 0.0)
	if _input_handler.is_just_pressed("jump"):
		jump_buffer_timer = _jump_buffer_timer
	else:
		jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)
	
	# Jump
	if jump_buffer_timer > 0.0 and coyote_time> 0.0:
		if _current_state == State.ATTACK:
			_current_attack = 0
			_combo_queued = false
			_combo_open = false
			_combo_timer = 0.0
			end_attack()
		
		velocity.y = _jump_force
		jump_buffer_timer = 0.0
		coyote_time = 0.0
		change_state(State.START_JUMP)
	if _input_handler.is_just_released("jump") and velocity.y < 0.0:
		velocity.y *= _jump_cut
	
	# Move
	match _current_state:
		State.IDLE:
			move(delta)
		State.RUN:
			move(delta)
			apply_gravity(delta)
		State.START_JUMP:
			move(delta)
			apply_gravity(delta)
		State.JUMP:
			move(delta)
			apply_gravity(delta)
		State.FALL:
			move(delta)
			apply_gravity(delta)
		State.LANDING:
			move(delta)
			apply_gravity(delta)
		State.ATTACK:
			move(delta)
			apply_gravity(delta)
	
	move_and_slide()
	
	# Update state
	if not _current_state == State.ATTACK:
		if not _current_state == State.START_JUMP and not _current_state == State.LANDING:
			if is_on_floor():
				if _current_state == State.JUMP or _current_state == State.FALL:
					change_state(State.LANDING)
				elif abs(velocity.x) > 0.1:
					change_state(State.RUN)
				else:
					change_state(State.IDLE)
			elif velocity.y < 0.0:
				change_state(State.JUMP)
			else:
				change_state(State.FALL)
	
	change_face_side()


func move(delta: float) -> void:
	if not _direction == Vector2.ZERO:
		velocity.x = move_toward(velocity.x, _direction.x * _max_speed, _acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, _friction * delta)


func apply_gravity(delta: float) -> void:
	velocity.y += _gravity * delta


func change_face_side() -> void:
	if velocity.x > 0:
		if hit_box.scale.x == -1:
			hit_box.scale.x = 1
		player_animated_sprite.flip_h = false
		attack_animated_sprite.flip_h = false
		arms_animated_sprite.flip_h = false
	if velocity.x < 0:
		if hit_box.scale.x == 1:
			hit_box.scale.x = -1
		player_animated_sprite.flip_h = true
		attack_animated_sprite.flip_h = true
		arms_animated_sprite.flip_h = true


func animation_controller() -> void:
	match _current_state:
		State.ATTACK:
			return
		State.IDLE:
			player_animated_sprite.play("idle")
		State.RUN:
			player_animated_sprite.play("run")
		State.START_JUMP:
			player_animated_sprite.play("start_jump")
		State.JUMP:
			player_animated_sprite.play("jump")
		State.FALL:
			player_animated_sprite.play("fall")
		State.LANDING:
			player_animated_sprite.play("landing")
		State.HURT:
			player_animated_sprite.play("hurt")
		State.DEAD:
			player_animated_sprite.play("dead")


func start_attack(attack: int) -> void:
	_max_speed = 10
	_current_attack = attack
	_combo_queued = false
	_combo_open = false
	_combo_timer = 0.0
	
	change_state(State.ATTACK)
	
	var animation_name: String = "attack_0" + str(attack)
	
	player_animated_sprite.play(animation_name)
	attack_animated_sprite.play(animation_name)
	arms_animated_sprite.play(animation_name)


func end_attack() -> void:
	_max_speed = _current_speed
	attack_animated_sprite.play("idle")
	arms_animated_sprite.play("idle")
	deactived_hit_box()


func change_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	
	_current_state = new_state
	animation_controller()


func animation_finished() -> void:
	match _current_state:
		State.ATTACK:
			if _current_attack == 1 and _combo_queued:
				start_attack(2)
				return
			
			_current_attack = 0
			_combo_queued = false
			_combo_open = false
			_combo_timer = 0.0
			
			end_attack()
			
			if not is_on_floor():
				if velocity.y < 0.0:
					change_state(State.JUMP)
				else:
					change_state(State.FALL)
			elif absf(velocity.x) > 0.1:
				change_state(State.RUN)
			else :
				change_state(State.IDLE)
		State.START_JUMP:
			if is_on_floor(): 
				change_state(State.LANDING)
			elif velocity.y < 0.0:
				change_state(State.JUMP)
			else:
				change_state(State.FALL)
		State.LANDING:
			if is_on_floor():
				if absf(velocity.x) > 0.1:
					change_state(State.RUN)
				else:
					change_state(State.IDLE)
			else:
				change_state(State.FALL)
		State.HURT:
			if _max_health == 0:
				change_state(State.DEAD)
			elif is_on_floor():
				if absf(velocity.x) > 0.1:
					change_state(State.RUN)
				else:
					change_state(State.IDLE)
			elif  velocity.y < 0.0:
				change_state(State.JUMP)
			else:
				change_state(State.FALL)


func take_damage(_area: Area2D) -> void:
	if _current_state == State.DEAD or _current_state == State.HURT:
		return
	
	_current_health = maxi(_current_health - 10, 0)
	damage_taked.emit()

	if _current_health == 0:
		change_state(State.DEAD)
		return
	
	_current_attack = 0
	_combo_queued = false
	_combo_open = false
	_combo_timer = 0.0
	end_attack()
	
	var direction: float = 0.0
	if player_animated_sprite.flip_h:
		direction = 1.0
	else:
		direction = -1.0
	
	velocity.x = _hurt_impulse.x * direction
	velocity.y = _hurt_impulse.y
	
	change_state(State.HURT)


func heal() -> void:
	if _current_state == State.DEAD or _current_state == State.HURT:
		return
	
	_current_health = mini(_current_health + 10, _max_health)
	heal_taked.emit()


func actived_hit_box() -> void:
	var collision: CollisionShape2D = hit_box.get_child(0)
	collision.set_deferred("disabled", false)
	hit_box.set_deferred("monitorable", true)
	hit_box.set_deferred("monitoring", true)


func deactived_hit_box() -> void:
	var collision: CollisionShape2D = hit_box.get_child(0)
	collision.set_deferred("disabled", true)
	hit_box.set_deferred("monitorable", false)
	hit_box.set_deferred("monitoring", false) 
		
