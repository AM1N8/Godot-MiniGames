extends CharacterBody2D
@export var health = 250
var SPEED = 150.0
var pawa = 10
var passive_dmg = false
var random 
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
	$AnimatedSprite2D.play("default")

func damage(dmg):
	health -= dmg
func die():
	random = randi_range(0,1)
	if random == 0:
		const exp = preload("res://abilites/shiled_item.tscn")
		var new_exp = exp.instantiate()
		new_exp.global_position = %pos.global_position
		get_parent().add_child(new_exp)
	if random == 1:
		const exp = preload("res://abilites/death_wheel_item.tscn")
		var new_exp = exp.instantiate()
		new_exp.global_position = %pos.global_position
		get_parent().add_child(new_exp)
	
	queue_free()

func passive_in():
	passive_dmg = true
func passive_out():
	passive_dmg = false
func _on_hit_body_entered(body):
	if body.has_method("take_hit"):
		body.take_hit(pawa)
