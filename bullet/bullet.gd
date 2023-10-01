extends CharacterBody2D

@export var speed = 400
@export var damage = 10
@export var accuracy = 10

var angle = 0
var mouse_position = Vector2.ZERO
var direction = Vector2.ZERO

func _ready():
	mouse_position = get_global_mouse_position()
	direction = position.direction_to(mouse_position)
	angle = get_angle_to(mouse_position)
	rotation = angle + 1.5708
	velocity = direction * speed

func _physics_process(delta):
	move_and_slide()

func _on_despawn_timer_timeout():
	self.queue_free()

func _on_attack_area_body_entered(body):
	if body.is_in_group("Enemy"):
		self.queue_free()
