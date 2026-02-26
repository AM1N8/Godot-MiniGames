extends CharacterBody2D

@export var speed :float = Variables.player_speed
@export var acceleration:float = 50

func _ready():
	$Body.play("default")
func _physics_process(delta):
	$wheel_lock.rotate(PI/56)
	var direction : Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	velocity.x = move_toward(velocity.x,speed*direction.x,acceleration)
	velocity.y = move_toward(velocity.y,speed*direction.y,acceleration)
	if direction.x > 0:
		$Body.flip_h = false
	
	if direction.x < 0:
		$Body.flip_h = true
		
	if Variables.health <= 0:
		dead()
		
	
	move_and_slide()

func experience(exp):
	$get_exp.pitch_scale = randf_range(0.5,1.5)
	$get_exp.play()
	Variables.exp_value += exp
	print(Variables.exp_value)
	
func take_hit(pawa):
	Variables.shake = true 
	Variables.health -= pawa
func dead():
	Variables.is_dead = true
	get_tree().paused = true
