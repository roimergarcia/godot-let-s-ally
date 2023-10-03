extends CharacterBody2D

@export var SPEED := 200
@export var STEERING_SPEED := 5
@export var FOLLOW_RADIUS := 100

const SAFE_PLAYER_DISTANCE := 150

enum FACE_DIRECTION { UP, DOWN, LEFT, RIGHT }
enum STATE { IDLE, RANDOM_WALK, FOLLOWING, FIGHT_WALK, FIGHTING }
var state : STATE = STATE.IDLE
var face_dir := FACE_DIRECTION.DOWN
  
@export var player : CharacterBody2D = null

var walking = false
var follow_player = false
var fighting = false

var player_last_position := Vector2.ZERO
var random_gen = RandomNumberGenerator.new()


func _physics_process(delta):
	walk_follow_player()
	random_movement()
	move_and_slide()
	
func walk_follow_player():
	if state == STATE.FOLLOWING:
		var player_position = player.position
		var distance = position.distance_to(player_position)
		if (distance <= SAFE_PLAYER_DISTANCE): 
			print("distance: %.02f" % distance)
			return
			
		var face_angle = position.angle_to_point(player_position) * 180 / PI
		walking = true
		
		velocity = position.direction_to(player_position) * SPEED
		if face_angle >= 45 and face_angle <= 45:
			face_dir = FACE_DIRECTION.RIGHT
			$ally_fighter_anim_2d.play("walk_fighter_right")
		elif face_angle > 45 and face_angle <= 135:
			face_dir = FACE_DIRECTION.DOWN
			$ally_fighter_anim_2d.play("walk_fighter_down")
		elif face_angle < 45 and face_angle >= -135:
			face_dir = FACE_DIRECTION.UP
			$ally_fighter_anim_2d.play("walk_fighter_up")
		else:
			face_dir = FACE_DIRECTION.LEFT
			$ally_fighter_anim_2d.play("walk_fighter_left")
	elif(state == STATE.IDLE or state == STATE.FIGHTING):
		match(face_dir):
			FACE_DIRECTION.UP:
				$ally_fighter_anim_2d.play("idle_fighter_down")
			FACE_DIRECTION.DOWN:
				$ally_fighter_anim_2d.play("idle_fighter_up")
			FACE_DIRECTION.LEFT:
				$ally_fighter_anim_2d.play("idle_fighter_left")
			FACE_DIRECTION.RIGHT:
				$ally_fighter_anim_2d.play("idle_fighter_right")


func idle_walk():
	if state != STATE.IDLE:
		return 
		
	match(face_dir):
		FACE_DIRECTION.UP:
			$ally_fighter_anim_2d.play("idle_fighter_down")
		FACE_DIRECTION.DOWN:
			$ally_fighter_anim_2d.play("idle_fighter_up")
		FACE_DIRECTION.LEFT:
			$ally_fighter_anim_2d.play("idle_fighter_left")
		FACE_DIRECTION.RIGHT:
			$ally_fighter_anim_2d.play("idle_fighter_right")

func random_movement():
	if state != STATE.RANDOM_WALK:
		return 
		
	var spin_chance = random_gen.randf_range(1, 100)
	var walk_chance = random_gen.randf_range(1, 100)
	
	if not follow_player and not walking and spin_chance <= 2:
		face_dir = FACE_DIRECTION.values()[randi() % FACE_DIRECTION.size()]
		
		if walk_chance <= 98:
			return 
		
		var divisor_velocidad = random_gen.randf_range(0.5, 4.0)
		var walk_time = random_gen.randf_range(0.5, 4.0)
		$walking_timer.wait_time = walk_time
		$walking_timer.start()
		walking = true
		match(face_dir):
			FACE_DIRECTION.UP:
				velocity = Vector2.UP * (SPEED / divisor_velocidad)
				$survivor_fighter_anim_2d.play("walk_fighter_down")
			FACE_DIRECTION.DOWN:
				velocity = Vector2.DOWN * (SPEED / divisor_velocidad)
				$ally_fighter_anim_2d.play("walk_fighter_up")
			FACE_DIRECTION.LEFT:
				velocity = Vector2.LEFT * (SPEED / divisor_velocidad)
				$ally_fighter_anim_2d.play("walk_fighter_left")
			FACE_DIRECTION.RIGHT:
				velocity = Vector2.RIGHT * (SPEED / divisor_velocidad)
				$ally_fighter_anim_2d.play("walk_fighter_right")

func _on_survivor_fighter_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		state = STATE.FOLLOWING
		follow_player = true
	
#func _on_survivor_fighter_detection_area_body_exited(body): 
#	var divisor_velocidad = random_gen.randf_range(1.5, 4.0)
#	if body.is_in_group("Player"):
#		player_last_position = player.position
#		$continue_following.wait_time = divisor_velocidad
#		$continue_following.start()
#		velocity = position.direction_to(player_last_position) * (SPEED / divisor_velocidad)
#		player = null
#		follow_player = false

func _on_walking_timer_timeout():
	velocity = Vector2.ZERO
	walking = false

#func _on_continue_following_timeout():
#	velocity = position.direction_to(player_last_position) * 0
#	walking = false

 
func move(target, delta):
	var distance : Vector2 = target - global_position
	
	if (distance.length() <= 20):
		return 
	
	var direction = distance.normalized()
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * STEERING_SPEED
	velocity +=  steering
	move_and_slide()

func _ready():
	pass
	
#****************************************	
# CODIGO VIEJO
#****************************************	

#enum ALLY_STATE { IDLE, RANDOM_WALK, FOLLOWING, FIGHT_WALK, FIGHTING }
#
#var face_dir : FACE_DIRECTION = FACE_DIRECTION.DOWN; 
#var state : ALLY_STATE = ALLY_STATE.IDLE

#
#	var s = random_gen.randf()
#	if (s < 0.5):
#		state = ALLY_STATE.IDLE
#	else: 
#		state = ALLY_STATE.RANDOM_WALK
#
#	var x = random_gen.randf()-0.5
#	var y = random_gen.randf()-0.5
#	walk_direction = Vector2(x, y)
#
#	pass
#
#	if(state == ALLY_STATE.IDLE):
#		var r = random_gen.randi_range(0, 4)
#		match(r):
#			0: 
#				face_dir= FACE_DIRECTION.UP
#				state = ALLY_STATE.RANDOM_WALK
#			1: 
#				face_dir= FACE_DIRECTION.DOWN
#				state = ALLY_STATE.RANDOM_WALK
#			2: 
#				face_dir= FACE_DIRECTION.LEFT
#				state = ALLY_STATE.RANDOM_WALK
#			3: 
#				face_dir= FACE_DIRECTION.RIGHT
#				state = ALLY_STATE.RANDOM_WALK
#
#	elif (state == ALLY_STATE.RANDOM_WALK):
#		var t = random_gen.randf()
#		if (t < 0.6):
#			state = ALLY_STATE.IDLE

##Inicializacíon
#func _ready():	 
#	pass

#
#func _physics_process(delta):
#	apply_move(delta)
#	#apply_animation()
#	move_and_slide()


