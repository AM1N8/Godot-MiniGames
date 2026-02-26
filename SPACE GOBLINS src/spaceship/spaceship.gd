extends CharacterBody2D

var speed = 500
var acceleration = 100
@onready var spawn_point : SpawnPoint = $SpawnPoint as SpawnPoint
@onready var BULLET = preload("res://weapons/cannon/cannon_bullet.tscn")
@onready var arrows = preload("res://weapons/arrows/arrows.tscn")

func _ready():
	$engine.play("default")
func _physics_process(delta):
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction * speed 
		
	animate()
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept") and !Variables.is_exhausted:
		shoot_center()
		Variables.stamina += 5
	elif Input.is_action_pressed("ui_accept") and $firerate.is_stopped() and !Variables.is_exhausted:
		$firerate.start(Variables.firerate)
		shoot_center()
	check_stamina()
func shoot_center():
	var bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %back_weapon.global_position
func damage_player(poid):
	if !Variables.is_invencible:
		Variables.is_invencible = true
		$invencibility.start()
		Variables.shake = true
		hit_stop(0.05,1.0)
		Variables.is_move_bar = true
		Variables.health -= poid
func hit_stop(timeScale, duration):
	Engine.time_scale = timeScale
	var timer = get_tree().create_timer(timeScale * duration)
	await timer.timeout
	Engine.time_scale = 1
func death():
	pass
func animate():
	if Variables.is_invencible:
		$AnimationPlayer.play("hit")
	if Variables.health >= Variables.max_health * 0.75 :
		$ship.play("base")
	elif Variables.health >= Variables.max_health * 0.50 :
		$ship.play("damaged1")
	elif Variables.health >= Variables.max_health * 0.25 :
		$ship.play("damaged2")
	else:
		$ship.play("damaged3")
func _on_invencibility_timeout():
	Variables.is_invencible = false	
func check_stamina():
	if Variables.stamina >= 100 :
		Variables.is_exhausted = true
		$exhausted.start()
	if Variables.is_exhausted :
		$AnimationPlayer.play("exhausted")
func _on_exhausted_timeout():
	Variables.is_exhausted = false
func get_arrows():
	var AR =  arrows.instantiate()
	add_child(AR)
	AR.global_position = global_position
	AR.global_rotation = global_rotation
	
