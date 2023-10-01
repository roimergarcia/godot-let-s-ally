extends CharacterBody2D

enum FASE_DIRECTION { UP, DOWN, LEFT, RIGHT }
enum STATUS { CHASING, ATTACKING, WALKING, WAITING }

const ENEMY_ATTACK = preload("res://enemy_attack/enemy_attack.tscn")

@export var speed = 120
@export var healt = 100

var face_dir : FASE_DIRECTION = FASE_DIRECTION.DOWN
var enemy_status : STATUS = STATUS.WAITING

var player = null
var player_last_position = Vector2(0,0)
var can_take_damage = true
var attacked = false

func chase_survivor():
	if enemy_status == STATUS.CHASING:
		var angle = position.angle_to_point (player.position)
		velocity = position.direction_to(player.position) * speed
		player_last_position = player.position
		if angle > -0.78 and angle < 0.78:
			face_dir = FASE_DIRECTION.RIGHT
			$enemy_anim_2d.play("walk_right")
			$attack_area/enemy_attack_area_coll.position.x = 8
			$attack_area/enemy_attack_area_coll.position.y = 0
		elif angle > 0.78 and angle < 2.35:
			face_dir = FASE_DIRECTION.DOWN
			$enemy_anim_2d.play("walk_front")
			$attack_area/enemy_attack_area_coll.position.x = 0
			$attack_area/enemy_attack_area_coll.position.y = 10
		elif angle < -0.78 and angle > -2.35:
			face_dir = FASE_DIRECTION.UP
			$enemy_anim_2d.play("walk_back")
			$attack_area/enemy_attack_area_coll.position.x = 0
			$attack_area/enemy_attack_area_coll.position.y = -15
		else:
			face_dir = FASE_DIRECTION.LEFT
			$enemy_anim_2d.play("walk_left")
			$attack_area/enemy_attack_area_coll.position.x = -8
			$attack_area/enemy_attack_area_coll.position.y = 0

func wait_survivor():
	var random_generator = RandomNumberGenerator.new()
	var spin_chance = random_generator.randf_range(1, 100)
	if enemy_status == STATUS.WAITING:
		if spin_chance <= 2:
			face_dir = FASE_DIRECTION.values()[randi() % FASE_DIRECTION.size()]
		velocity = Vector2.ZERO
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
	var walk_chance = random_generator.randf_range(0.5, 100)
	if enemy_status == STATUS.WAITING and walk_chance < 0.7:
		var speed_divider = random_generator.randf_range(1, 4.0)
		var walk_time = random_generator.randf_range(1, 4.0)
		enemy_status = STATUS.WALKING
		$walking.wait_time = walk_time
		$walking.start()
		match(face_dir):
			FASE_DIRECTION.UP:
				velocity = Vector2.UP * (speed / speed_divider)
				$enemy_anim_2d.play("walk_back")
			FASE_DIRECTION.DOWN:
				velocity = Vector2.DOWN * (speed / speed_divider)
				$enemy_anim_2d.play("walk_front")
			FASE_DIRECTION.LEFT:
				velocity = Vector2.LEFT * (speed / speed_divider)
				$enemy_anim_2d.play("walk_left")
			FASE_DIRECTION.RIGHT:
				velocity = Vector2.RIGHT * (speed / speed_divider)
				$enemy_anim_2d.play("walk_right")

func attack_survivor():
	if enemy_status == STATUS.ATTACKING and not attacked:
		$attack_cooldown.start()
		attacked = true
		velocity = Vector2.ZERO
		match(face_dir):
			FASE_DIRECTION.UP:
				$enemy_anim_2d.play("attack_back")
			FASE_DIRECTION.DOWN:
				$enemy_anim_2d.play("attack_front")
			FASE_DIRECTION.LEFT:
				$enemy_anim_2d.play("attack_left")
			FASE_DIRECTION.RIGHT:
				$enemy_anim_2d.play("attack_right")
		var attack = ENEMY_ATTACK.instantiate()
		get_parent().add_child(attack)
		attack.position = player.position

func _physics_process(delta):
	chase_survivor()
	wait_survivor()
	random_movement()
	attack_survivor()
	move_and_slide()


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		enemy_status = STATUS.CHASING

func _on_detection_area_body_exited(body):
	var random_generator = RandomNumberGenerator.new()
	var speed_divider = random_generator.randf_range(1.5, 4.0)
	if body.is_in_group("Player"):
		$continue_chasing.wait_time = speed_divider
		$continue_chasing.start()
		velocity = position.direction_to(player_last_position) * (speed / speed_divider)
		player = null
		enemy_status = STATUS.WALKING

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		enemy_status = STATUS.ATTACKING

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		enemy_status = STATUS.CHASING

func _on_continue_chasing_timeout():
	if enemy_status == STATUS.WALKING:
		velocity = Vector2.ZERO
		enemy_status = STATUS.WAITING

func _on_walking_timeout():
	if enemy_status == STATUS.WALKING:
		velocity = Vector2.ZERO
		enemy_status = STATUS.WAITING

func _on_attack_cooldown_timeout():
	if enemy_status == STATUS.ATTACKING:
		attacked = false

