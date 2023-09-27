extends CharacterBody2D

enum FASE_DIRECTION { UP, DOWN, LEFT, RIGHT }

@export var speed = 120
@export var healt = 100

var player = null
var player_chase = false
var player_inattack_zone = false
var player_last_position = Vector2(0,0)
var can_take_damage = true

var walking = false
var walk_direction := Vector2()
var face_dir : FASE_DIRECTION = FASE_DIRECTION.DOWN; 

func chase_player():
	if player_chase and not player_inattack_zone:
		var angulo = position.angle_to_point (player.position)
		walking = true
		#print((player.position - position).normalized())
		#print(position.dot((player.position - position).normalized()))
		#print(position.angle_to_point (player.position))
		velocity = position.direction_to(player.position) * speed
		if angulo > -0.75 and angulo < 0.75:
			face_dir = FASE_DIRECTION.RIGHT
			$enemy_anim_2d.play("walk_right")
			$attack_area/enemy_attack_area_coll.position.x = 7
			$attack_area/enemy_attack_area_coll.position.y = 0
		elif angulo > 0.75 and angulo < 2.25:
			face_dir = FASE_DIRECTION.DOWN
			$enemy_anim_2d.play("walk_front")
			$attack_area/enemy_attack_area_coll.position.x = 0
			$attack_area/enemy_attack_area_coll.position.y = 7
		elif angulo < -0.75 and angulo > -2.25:
			face_dir = FASE_DIRECTION.UP
			$enemy_anim_2d.play("walk_back")
			$attack_area/enemy_attack_area_coll.position.x = 0
			$attack_area/enemy_attack_area_coll.position.y = -20
		else:
			face_dir = FASE_DIRECTION.LEFT
			$enemy_anim_2d.play("walk_left")
			$attack_area/enemy_attack_area_coll.position.x = -7
			$attack_area/enemy_attack_area_coll.position.y = 0
	else:
		if not walking:
			match(face_dir):
				FASE_DIRECTION.UP:
					$enemy_anim_2d.play("idle_back")
				FASE_DIRECTION.DOWN:
					$enemy_anim_2d.play("idle_front")
				FASE_DIRECTION.LEFT:
					$enemy_anim_2d.play("idle_left")
				FASE_DIRECTION.RIGHT:
					$enemy_anim_2d.play("idle_right")

func random_movement():
	var random_generator = RandomNumberGenerator.new()
	var spin_chance = random_generator.randf_range(1, 100)
	var walk_chance = random_generator.randf_range(1, 100)
	var _face_directions = ["UP","DOWN","LEFT","RIGHT"]
	
	if not player_chase and not walking and spin_chance <= 2:
		face_dir = FASE_DIRECTION[_face_directions[randi() % _face_directions.size()]]
		print(face_dir)
		
		if walk_chance > 98:
			var divisor_velocidad = random_generator.randf_range(0.5, 4.0)
			var walk_time = random_generator.randf_range(0.5, 4.0)
			$walking.wait_time = walk_time
			$walking.start()
			walking = true
			match(face_dir):
				FASE_DIRECTION.UP:
					velocity = Vector2.UP * (speed / divisor_velocidad)
					$enemy_anim_2d.play("walk_back")
				FASE_DIRECTION.DOWN:
					velocity = Vector2.DOWN * (speed / divisor_velocidad)
					$enemy_anim_2d.play("walk_front")
				FASE_DIRECTION.LEFT:
					velocity = Vector2.LEFT * (speed / divisor_velocidad)
					$enemy_anim_2d.play("walk_left")
				FASE_DIRECTION.RIGHT:
					velocity = Vector2.RIGHT * (speed / divisor_velocidad)
					$enemy_anim_2d.play("walk_right")
		
		
		

func aleatory_movement():
	pass

func exec_animation():
	pass

func _physics_process(delta):
	chase_player()
	random_movement()
	move_and_slide()


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	var random_generator = RandomNumberGenerator.new()
	var divisor_velocidad = random_generator.randf_range(1.5, 4.0)
	if body.is_in_group("Player"):
		player_last_position = player.position
		$continue_chasing.wait_time = divisor_velocidad
		$continue_chasing.start()
		velocity = position.direction_to(player_last_position) * (speed / divisor_velocidad)
		player = null
		player_chase = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		player_inattack_zone = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		player_inattack_zone = false


func _on_continue_chasing_timeout():
	velocity = position.direction_to(player_last_position) * 0
	walking = false


func _on_walking_timeout():
	velocity = Vector2.ZERO
	walking = false
