extends Node2D
var speed = 500
func _ready():
	$Area2D/AnimatedSprite2D.play("default")
func _physics_process(delta):
	position.x += speed * delta
