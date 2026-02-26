extends CharacterBody2D
var speed = 150
var health = 60
var dmg = 2
func _ready():
	$AnimatedSprite2D.play("default")
	damage(0)
func _physics_process(delta):
	bounds()
	rotate(PI/126)
	velocity.x = -speed * delta * 100
	move_and_slide()
	if health <= 0:
		die()
func die():
	Variables.shake = true
	$hit/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("explode")
	Variables.score += 5
	await $AnimatedSprite2D.animation_finished
	queue_free()
func damage(poid):
	$AnimationPlayer.play("flash_hit")
	position.x += 15
	health -= poid
func bounds():
	if position.x < -500 or position.x > 5000:
		queue_free()


func _on_hit_body_entered(body):
	if body.has_method("damage_player"):
		body.damage_player(dmg)
