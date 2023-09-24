extends CharacterBody2D

enum FACE_DIRECTION { UP, DOWN, LEFT, RIGHT }

@export var speed = 200
@export var rotation_speed = 5

var walk_direction := Vector2(0, -1)
var face_dir : FACE_DIRECTION = FACE_DIRECTION.DOWN; 

var random_gen = RandomNumberGenerator.new()

var player : CharacterBody2D = null
var is_following_player := false

func apply_move(delta):
	if not is_following_player:
		if random_gen.randf() > .8:
			#walk_direction = walk_direction.rotated() * random_gen.randf_range(0, 360)
			pass
		
	
	pass

func _physics_process(delta):
	
	apply_move(delta)
	move_and_slide()
