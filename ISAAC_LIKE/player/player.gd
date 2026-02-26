extends CharacterBody2D


const SPEED = 200.0

func _physics_process(delta):
	
	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if GameManager.HP == 0:
		Die() 
	move_and_slide()
func Die():
	print("YOU DIED")
	GameManager.HP = 3
