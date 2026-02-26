extends CharacterBody2D
var speed = 100
var health = 40
var BULLET = preload("res://enemies/bullets/bullet.tscn")
func _ready():
	$engine.play("default")
func _physics_process(delta):
	bounds()
	velocity.x = -speed * delta * 100
	move_and_slide()
	if health <= 0:
		die()
func die():
	Variables.shake = true
	$engine.visible = false
	$ship.play("explode")
	health = 69
	Variables.score += 5
	await $ship.animation_finished
	queue_free()
		
func shoot():
	var bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos.global_position
func damage(poid):
	$AnimationPlayer.play("flash_hit")
	health -= poid
func _on_timer_timeout():
	shoot()
func bounds():
	if position.x < -500 or position.x > 5000:
		queue_free()

