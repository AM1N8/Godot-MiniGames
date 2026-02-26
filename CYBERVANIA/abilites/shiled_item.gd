extends Area2D
var player
var follow = false
var acc =0.15

func _physics_process(delta):
	if follow:
		global_position.x = lerp(global_position.x,player.global_position.x,acc)
		global_position.y = lerp(global_position.y,player.global_position.y,acc)



func _on_take_body_entered(body):
	if body.has_method("experience"):
		if Variables.shield_on:
			Variables.shield_scale *= 1.5
		else:
			Variables.shield_on = true
		queue_free()


func _on_body_entered(body):
	if body.has_method("experience"):
		player = body
		follow = true
	
