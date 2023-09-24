extends CharacterBody2D

enum FACE_DIRECTION { UP, DOWN, LEFT, RIGHT }

@export var speed = 200
@export var rotation_speed = 5

var walk_direction := Vector2(0, -1)
var face_dir : FACE_DIRECTION = FACE_DIRECTION.DOWN; 

func get_input():
#	rotation_direction = Input.get_axis("left", "right")
#	velocity = -transform.y * Input.get_axis("down", "up") * speed
 
	#Walk Animation
	if Input.is_action_pressed("up"):
		face_dir = FACE_DIRECTION.UP
		$player_anim_2d.play("walk_up")
	elif Input.is_action_pressed("down"):
		face_dir = FACE_DIRECTION.DOWN
		$player_anim_2d.play("walk_down")
	elif Input.is_action_pressed("left"):
		face_dir = FACE_DIRECTION.LEFT
		$player_anim_2d.play("walk_left")
	elif Input.is_action_pressed("right"):
		face_dir = FACE_DIRECTION.RIGHT
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
	
	var input_direction := Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	#rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func player():
	pass
