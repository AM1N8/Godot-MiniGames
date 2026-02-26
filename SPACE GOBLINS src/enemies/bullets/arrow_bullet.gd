extends Node2D
var speed = 800
var travel_distance = 0
var range = 2000
var dmg = 20
func _ready():
	$Area2D/AnimatedSprite2D.play("default")

func _physics_process(delta):
	position.x += speed * delta
	bounds()
	
func bounds():
	if position.x < -500 or position.x > 5000:
		queue_free()



func _on_area_2d_body_entered(body):
	if body.has_method("damage") :
		body.damage(dmg)
		queue_free()
