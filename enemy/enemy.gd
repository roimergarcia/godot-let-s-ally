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
	if player_chase:
		print("player_chase: ", player_chase)
		print("player position: ", player.position)
		print("enemy position: ", position)
		position += (player.position - position) / speed
		if player.position.y < position.y:
			$enemy_anim_2d.play("walk_back")
		else:
			$enemy_anim_2d.play("walk_front")
	else:
		$enemy_anim_2d.play("idle_front")

func aleatory_movement():
	pass

func exec_animation():
	pass

func _physics_process(delta):
	chase_player()


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false

func _on_attack_area_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_attack_area_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
