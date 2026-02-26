extends CharacterBody2D
var health = 20
var SPEED = 50.0
var pawa = 10
var passive_dmg = false
@onready var player = get_node("/root/tester/player")


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	animate()
	move_and_slide()
	if passive_dmg:
		damage(0.5)
	if health <= 0:
		
		die()
func animate():
	if position.x > player.position.x:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("default")
func damage(dmg):
	health -= dmg
func die():
	const exp = preload("res://abilites/exp.tscn")
	var new_exp = exp.instantiate()
	new_exp.global_position = %posi.global_position
	get_parent().add_child(new_exp)
	queue_free()

func passive_in():
	passive_dmg = true
func passive_out():
	passive_dmg = false

func _on_hit_body_entered(body):
	if body.has_method("take_hit"):
		body.take_hit(pawa)
