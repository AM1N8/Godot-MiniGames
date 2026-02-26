extends Area2D

func _physics_process(delta):
	$"../Timer".wait_time = Variables.bullet_time
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target = enemies_in_range.pick_random()
		%lock.look_at(target.global_position)
	

func shoot():
	$"../lazer_gun".pitch_scale = randf_range(0.75,1.25)
	$"../lazer_gun".play()
	const bullet = preload("res://abilites/bullet.tscn")
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = %lock.global_position
	new_bullet.global_rotation = %lock.global_rotation
	%lock.add_child(new_bullet)
	
	



func _on_timer_timeout():
	shoot()
