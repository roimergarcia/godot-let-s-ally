extends CharacterBody2D

enum FASE_DIRECTION { UP, DOWN, LEFT, RIGHT }

@export var speed = 200
@export var rotation_speed = 5

var walk_direction := Vector2(0, -1)
var face_dir : FASE_DIRECTION = FASE_DIRECTION.DOWN; 

func get_input():
#	rotation_direction = Input.get_axis("left", "right")
#	velocity = -transform.y * Input.get_axis("down", "up") * speed
 
	#Walk Animation
	if Input.is_action_pressed("up"):
		face_dir = FASE_DIRECTION.UP
		$player_anim_2d.play("walk_up")
	elif Input.is_action_pressed("down"):
		face_dir = FASE_DIRECTION.DOWN
		$player_anim_2d.play("walk_down")
	elif Input.is_action_pressed("left"):
		face_dir = FASE_DIRECTION.LEFT
		$player_anim_2d.play("walk_left")
	elif Input.is_action_pressed("right"):
		face_dir = FASE_DIRECTION.RIGHT
		$player_anim_2d.play("walk_right")
	#Idle Animation
	else:
		match(face_dir):
			FASE_DIRECTION.UP:
				$player_anim_2d.play("idle_up")
			FASE_DIRECTION.DOWN:
				$player_anim_2d.play("idle_down")
			FASE_DIRECTION.LEFT:
				$player_anim_2d.play("idle_left")
			FASE_DIRECTION.RIGHT:
				$player_anim_2d.play("idle_right")

	var input_direction := Input.get_vector("left", "right", "up", "down")
	#print_debug(input_direction)
	velocity = input_direction * speed

func _physics_prosdcess(delta):
	get_input()
	#rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
