extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 5

var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = -transform.y * Input.get_axis("down", "up") * speed
#	var input_direction = Input.get_vector("left", "right", "up", "down")
#	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
