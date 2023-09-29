extends CharacterBody2D

func _ready():
	pass

func _on_attack_area_body_entered(body):
	$attack_anim_2d.visible = true
	$attack_anim_2d.play("attack")
#	self.queue_free()
	print(body.name)


func _on_attack_anim_2d_animation_finished():
	print("terminó")
	self.queue_free()
