extends Node2D
var BULLET = preload("res://weapons/energy_ball/energy_ball.tscn")
func _ready():
	$AnimatedSprite2D.play("default")

func shoot():
	var bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos.global_position

func _on_timer_timeout():
	pass


func _on_animated_sprite_2d_animation_finished():
	shoot()
	$AnimatedSprite2D.play("default")
	
