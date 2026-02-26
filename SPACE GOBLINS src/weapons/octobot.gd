extends CharacterBody2D
var speed = 100
var health = 100
var dmg = 1
var particle = preload("res://UI/explode_particle.tscn")
func _ready():
	damage(0)
func _physics_process(delta):
	rotatelocks()
	bounds()
	velocity.x = -speed * delta * 100
	move_and_slide()
	if health <= 0:
		die()
func rotatelocks():
	$lock1.rotate(PI/100)
func bounds():
	if position.x < -500 or position.x > 5000:
		queue_free()
func die():
	Variables.shake = true
	var instance = particle.instantiate()
	instance.global_position = self.position
	get_tree().get_root().add_child(instance)
	Variables.score += 5
	queue_free()
func damage(poid):
	$AnimationPlayer.play("hit_flash")
	health -= poid
func _on_hit_body_entered(body):
	if body.has_method("damage_player"):
		body.damage_player(dmg)
func _on_hit_2_body_entered(body):
	if body.has_method("damage_player"):
		body.damage_player(dmg)
