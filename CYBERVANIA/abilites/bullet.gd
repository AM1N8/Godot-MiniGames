extends Area2D
var dmg = 10
var traveled_distance = 0
var speed = 500
var range = 1000
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	traveled_distance += speed * delta
	if traveled_distance > range :
		queue_free()



func _on_body_entered(body):
	
	if body.has_method("damage"):
		body.damage(dmg)
		queue_free()
