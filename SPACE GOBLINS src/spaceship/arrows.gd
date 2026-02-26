extends Node2D
var BULLET = preload("res://enemies/bullets/arrow_bullet.tscn")
var frame = 0
var delay = 0.2
func _ready():
	pass
func _physics_process(delta):
	pass
func shoot():
	$AnimatedSprite2D.play("default")
	var bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos1.global_position
	await get_tree().create_timer(delay).timeout
	bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos2.global_position
	await get_tree().create_timer(delay).timeout
	bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos3.global_position
	await get_tree().create_timer(delay).timeout
	bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos4.global_position
	await get_tree().create_timer(delay).timeout
	bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos5.global_position
	await get_tree().create_timer(delay).timeout
	bullet =  BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = %pos6.global_position
func _on_fire_timeout():
	shoot()
