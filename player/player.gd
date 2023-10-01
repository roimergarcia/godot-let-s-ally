extends CharacterBody2D

enum FACE_DIRECTION { UP, DOWN, LEFT, RIGHT }

const BULLET = preload("res://bullet/bullet.tscn")

@export var speed = 200
@export var rotation_speed = 5

var walk_direction := Vector2(0, -1)
var face_dir : FACE_DIRECTION = FACE_DIRECTION.DOWN; 

func get_input():
	var mouse_position = get_global_mouse_position()
	var angle = get_angle_to(mouse_position)
	var input_direction := Input.get_vector("left", "right", "up", "down")
	
	if angle < -2.35 or angle > 2.35:
		face_dir = FACE_DIRECTION.LEFT
	elif angle > 0.78:
		face_dir = FACE_DIRECTION.DOWN
	elif angle > -0.78:
		face_dir = FACE_DIRECTION.RIGHT
	else:
		face_dir = FACE_DIRECTION.UP
	
	#Walk Animation
	if input_direction != Vector2.ZERO:
		match(face_dir):
			FACE_DIRECTION.UP:
				$player_anim_2d.play("walk_up")
			FACE_DIRECTION.DOWN:
				$player_anim_2d.play("walk_down")
			FACE_DIRECTION.LEFT:
				$player_anim_2d.play("walk_left")
			FACE_DIRECTION.RIGHT:
				$player_anim_2d.play("walk_right")
	#Idle Animation
	else:
		match(face_dir):
			FACE_DIRECTION.UP:
				$player_anim_2d.play("idle_up")
			FACE_DIRECTION.DOWN:
				$player_anim_2d.play("idle_down")
			FACE_DIRECTION.LEFT:
				$player_anim_2d.play("idle_left")
			FACE_DIRECTION.RIGHT:
				$player_anim_2d.play("idle_right")
	
	velocity = input_direction * speed

func attack_enemy():
	if Input.is_action_just_pressed("click"):
		var attack = BULLET.instantiate()
		match(face_dir):
			FACE_DIRECTION.UP:
				$Marker2D.position.x = 5
				$Marker2D.position.y = -13
			FACE_DIRECTION.DOWN:
				$Marker2D.position.x = -5
				$Marker2D.position.y = -5
			FACE_DIRECTION.LEFT:
				$Marker2D.position.x = -13
				$Marker2D.position.y = -15
			FACE_DIRECTION.RIGHT:
				$Marker2D.position.x = 13
				$Marker2D.position.y = -15
		attack.position = $Marker2D.global_position
		get_parent().add_child(attack)

func _process(delta):
	attack_enemy()

func _physics_process(delta):
	get_input()
	#rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

