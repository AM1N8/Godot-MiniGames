extends Node2D
var random
var wave = 1
var wave_count = 1

func _ready():
	pass


func spawn_eye():
	var mob = preload("res://enemy/eyeball.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf_range(0,1)
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)
func spawn_slime():
	var mob = preload("res://enemy/slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf_range(0,1)
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)
func spawn_CUBE():
	var mob = preload("res://enemy/cube.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf_range(0,1)
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)
func spawn_card():
	var mob = preload("res://enemy/evil_8.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf_range(0,1)
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)
func spawn_planet():
	var mob = preload("res://enemy/eye_planet.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf_range(0,1)
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)
func spawn_fire():
	var mob = preload("res://enemy/firenig.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf_range(0,1)
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)

func _on_timer_timeout():
	if wave == 5 : 
		spawn_CUBE()
		wave = 1
	if wave_count <= 15 :
		random = randi_range(0,4)
		if random == 4:
			spawn_slime()
		else :
			spawn_eye()
	if wave_count > 15 and wave_count <= 30 :
		random = randi_range(1,6)
		if random == 1:
			spawn_eye()
		if random == 2 or random == 3 or random == 4:
			spawn_slime()
		if random == 4:
			spawn_card()
		if random == 5:
			spawn_eye()
	if wave_count > 30 and wave_count <= 50  :
		random = randi_range(1,4)
		if random == 1:
			spawn_eye()
		if random == 2:
			spawn_slime()
		if random == 3:
			spawn_card()
		if random == 4:
			spawn_planet()
	if wave_count > 50  :
		random = randi_range(1,4)
		if random == 1:
			spawn_fire()
		if random == 2:
			spawn_slime()
		if random == 3:
			spawn_card()
		if random == 4:
			spawn_planet()
	


func _on_wave_timeout():
	if $Timer.wait_time >= 0.1:
		$Timer.wait_time *= 0.9
	wave += 1
	wave_count += 1
	print("wave : ",wave_count)
