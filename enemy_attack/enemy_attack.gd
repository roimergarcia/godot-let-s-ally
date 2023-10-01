extends CharacterBody2D

func _ready():
	pass

func _on_attack_area_body_entered(body):
	$attack_anim_2d.visible = true
	$attack_anim_2d.play("attack")


func _on_attack_anim_2d_animation_finished():
	self.queue_free()
