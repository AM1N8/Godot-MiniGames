extends Area2D
var player
var amount = 2
var follow = false
var acc =0.15

func _physics_process(delta):
	if follow:
		global_position.x = lerp(global_position.x,player.global_position.x,acc)
		global_position.y = lerp(global_position.y,player.global_position.y,acc)




func _on_body_entered(body):
	if body.has_method("experience"):
		player = body
		follow = true
		print("got coin")


func _on_get_coin_body_entered(body):
	if body.has_method("experience"):
		body.experience(amount)
		Variables.score +=5
		queue_free()
