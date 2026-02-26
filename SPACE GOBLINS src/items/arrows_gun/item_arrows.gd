extends Node2D
var player
var speed = 100
var follow = false
var acc =0.15
var increment = 0
func _ready():
	$AnimatedSprite2D.play("default")


func _physics_process(delta):
	increment +=5
	if follow:
		global_position.x = lerp(global_position.x,player.global_position.x,acc)
		global_position.y = lerp(global_position.y,player.global_position.y,acc)
	else:
		position.x -= speed * delta
		position.y += sin( increment * delta) * 2
func _on_take_body_entered(body):
	if body.has_method("get_arrows"):
		queue_free()

func _on_body_entered(body):
	if body.has_method("get_arrows"):
		player = body
		body.get_arrows()
		follow = true
	
