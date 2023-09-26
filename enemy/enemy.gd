extends CharacterBody2D

enum FASE_DIRECTION { UP, DOWN, LEFT, RIGHT }

@export var speed = 200
@export var healt = 100

var player = null
var player_chase = false
var player_inattack_zone = false
var can_take_damage = true

var walk_direction := Vector2(0, -1)
var face_dir : FASE_DIRECTION = FASE_DIRECTION.DOWN; 

func chase_player():
	if player_chase and not player_inattack_zone:
		var angulo = position.angle_to_point (player.position)
		#print((player.position - position).normalized())
		#print(position.dot((player.position - position).normalized()))
		#print(position.angle_to_point (player.position))
		position += (player.position - position) / speed
		if angulo > -0.75 and angulo < 0.75:
			face_dir = FASE_DIRECTION.RIGHT
			$enemy_anim_2d.play("walk_right")
		elif angulo > 0.75 and angulo < 2.25:
			face_dir = FASE_DIRECTION.DOWN
			$enemy_anim_2d.play("walk_front")
		elif angulo < -0.75 and angulo > -2.25:
			face_dir = FASE_DIRECTION.UP
			$enemy_anim_2d.play("walk_back")
		else:
			face_dir = FASE_DIRECTION.LEFT
			$enemy_anim_2d.play("walk_left")
	else:
		match(face_dir):
			FASE_DIRECTION.UP:
				$enemy_anim_2d.play("idle_back")
			FASE_DIRECTION.DOWN:
				$enemy_anim_2d.play("idle_front")
			FASE_DIRECTION.LEFT:
				$enemy_anim_2d.play("idle_left")
			FASE_DIRECTION.RIGHT:
				$enemy_anim_2d.play("idle_right")

func aleatory_movement():
	pass

func exec_animation():
	pass

func _physics_process(delta):
	chase_player()


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		player_inattack_zone = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		player_inattack_zone = false
