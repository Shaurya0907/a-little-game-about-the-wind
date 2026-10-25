extends CharacterBody2D

@onready var player: AnimatedSprite2D = $player_animated
@onready var anim_player: AnimationPlayer = $player_animated/AnimationPlayer
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var heart_1: Sprite2D = $"../CanvasLayer/heart1"
@onready var heart_2: Sprite2D = $"../CanvasLayer/heart2"
@onready var heart_3: Sprite2D = $"../CanvasLayer/heart3"
@onready var wind_parry: Timer = $wind_parry
@onready var damage: AudioStreamPlayer2D = $damage
@onready var walking: AudioStreamPlayer2D = $walking
@onready var wind_gust: AudioStreamPlayer2D = $"../wind_gust"



'''
NOTE:
I have made the wind code with the help of Ai. Yes, i had to as i was VERY short of time due to my heavy prior commitments and exams.
I only have about 4 to 5 hours approx to complete the game.
everything else is purely made by me including the art and everything else and rest of the game WILL be made by me. I didnt want to use AI. If i wont be able to submit the game on time, now you know the real reason.
I again appologize for the AI usage (I dont know how much is permitted but for me it should be nil)
'''
const SPEED = 70.0
const GRAVITY = 1200.0
const JUMP_VELOCITY = -240.0

const PLAYER_POSITION_OLD = Vector2i(98, 135)
const CAMERA_POSITION_OLD = Vector2i(160, 90)

const WIND_SCENE = preload("res://scenes/wind.tscn")

const WIND_MAX_PUSH = 120.0
const WIND_ACCELERATION = 350.0
const WIND_FADE = 450.0

var fall_protection =false
var wind_catch = false
var is_wind_lifting = false

# Fall damage
const FALL_DAMAGE_HEIGHT = 40.0
const FALL_DAMAGE_AMOUNT = 25



var player_health = 100

var wind_timer = 2.0
var wind_duration = 0.0
var wind_direction = -1.0
var wind_push = 0.0
var wind_lifting = false

var side_wind: AnimatedSprite2D
var upward_wind: AnimatedSprite2D

var fall_peak_y = 0.0
var was_on_floor = false


func _ready() -> void:
	randomize()
	camera_2d.make_current()

	# Create the two wind animations
	side_wind = WIND_SCENE.instantiate() as AnimatedSprite2D
	upward_wind = WIND_SCENE.instantiate() as AnimatedSprite2D

	add_child(side_wind)
	add_child(upward_wind)

	# uh this prevents the camera from going to the development zone ;)
	camera_2d.limit_left = 0
	camera_2d.limit_right = 1900
	
	# adds wind behind the player
	side_wind.z_index = -1
	upward_wind.z_index = -1

	side_wind.visible = false
	upward_wind.visible = false

	# for making the player jump when wind gows upward
	upward_wind.position = Vector2(0, 22)

	fall_peak_y = global_position.y
	was_on_floor = is_on_floor()


func _physics_process(delta: float) -> void:
	
	var on_floor_before_move = is_on_floor()
	
	
	camera_2d.global_position.x = (
		global_position.x
		+ CAMERA_POSITION_OLD.x
		- PLAYER_POSITION_OLD.x
	)

	var direction = Input.get_axis("move_backward","move_forward")

	# to find the max jump point
	if on_floor_before_move:
		fall_peak_y = global_position.y
	else:
		fall_peak_y = minf(
			fall_peak_y,
			global_position.y
		)

	# GRAVITYYYY
	if not on_floor_before_move:
		velocity.y += GRAVITY * delta
	if is_wind_lifting and velocity.y > 0:
		wind_parry.start()
		is_wind_lifting = false
	if Input.is_action_just_pressed("wind catch") and not on_floor_before_move and velocity.y > 0.0 and not wind_catch and not wind_parry.is_stopped():
		fall_protection = true
		wind_catch =true
		velocity.y = minf(velocity.y, 100)
	
	
	# JUMP
	var just_jumped = Input.is_action_just_pressed("jump") and on_floor_before_move

	if just_jumped:
		velocity.y = JUMP_VELOCITY

	#wind
	if wind_duration > 0.0:
		wind_duration = maxf(
			0.0,
			wind_duration - delta
		)

		wind_push = move_toward(
			wind_push,
			wind_direction * WIND_MAX_PUSH,
			WIND_ACCELERATION * delta
		)

	else:
		wind_lifting = false

		wind_timer -= delta

		wind_push = move_toward(
			wind_push,
			0.0,
			WIND_FADE * delta
		)

		
		if wind_timer <= 0.0:

			wind_timer = randf_range(3.0, 5.0)
			wind_duration = randf_range(0.8, 1.3)
			
			
			wind_direction = -1.0

			side_wind.position = Vector2(
				-wind_direction * 28.0,
				-3.0
			)

			#side_wind.flip_h = wind_direction > 0.0
			side_wind.frame = 0
			side_wind.play("wind")
			wind_gust.play()

			# for upward wind
			wind_lifting = randf() < 0.95
			
			if wind_lifting:
				velocity.y = minf(
					velocity.y,
					-randf_range(300.0, 380.0)
				)
				is_wind_lifting = true
				
				upward_wind.frame = 0
				upward_wind.play("wind")
				wind_gust.play()
	# to disable/enable wind
	side_wind.visible = wind_duration > 0.0

	upward_wind.visible = wind_duration > 0.0 and wind_lifting

	# movement
	velocity.x = direction * SPEED + wind_push

	# flips the character
	if velocity.x > 0.0:
		player.flip_h = false
	elif velocity.x < 0.0:
		player.flip_h = true

	if just_jumped or not on_floor_before_move or velocity.y < 0.0:
		if anim_player.current_animation != "jump":
			anim_player.play("jump")

	elif direction != 0.0:
		if anim_player.current_animation != "walking":
			anim_player.play("walking")
			walking.play()
	
	else:
		if anim_player.current_animation != "idle":
			anim_player.play("idle")
			walking.stop()

	move_and_slide()
	
	var on_floor_after_move = is_on_floor()
	# fall damage :)))
	
	if on_floor_before_move:
		fall_protection = false
		wind_catch = false
	
	if not heart_1.visible:
		get_tree().quit()
		pass
	
	if on_floor_after_move and not was_on_floor:

		var fall_height = global_position.y - fall_peak_y

		if fall_height > FALL_DAMAGE_HEIGHT and not fall_protection:
			if heart_1.visible and heart_2.visible and heart_3.visible:
				heart_3.hide()
			elif not heart_3.visible and heart_2.visible:
				heart_2.hide()
			elif not heart_3.visible and not heart_2.visible:
				heart_1.hide()
			damage.play()
	was_on_floor = on_floor_after_move
