extends CharacterBody2D


var SPEED = Vector2(randf_range(50,150),randf_range(50,150))

func _physics_process(delta):
	velocity = SPEED
	move_and_slide()
	



func _on_topdown_body_entered(body):
	if body.is_in_group("tiles") :
		SPEED.y = -SPEED.y
	if body.is_in_group("Player"):
		SPEED.y = -SPEED.y
		GameManager.HP -=1


func _on_leftright_body_entered(body):
	if body.is_in_group("tiles") :
		SPEED.x = -SPEED.x
	if body.is_in_group("Player"):
		SPEED.x = -SPEED.x
		GameManager.HP -=1
