extends Node2D
var ship = preload("res://enemies/scout_ship.tscn")
var astroide = preload("res://enemies/astroide.tscn")
var octobot = preload("res://enemies/octobot.tscn")
func _ready():
	pass


func _on_timer_timeout():
	var random = randi_range(0,10)*0.1
	var rng = randi_range(0,100)
	var liner = randi_range(0,100)
	$spawnline/PathFollow2D.progress_ratio = random
	if liner >=95:
		spawnline(ship)
	elif liner >= 90:
		spawnv(ship)
	else:
		var s
		if rng <=70:
			s =  ship.instantiate()
		elif rng <=90:
			s = astroide.instantiate()
		else:
			s = octobot.instantiate()
		get_tree().get_root().add_child(s)
		s.global_position = $spawnline/PathFollow2D.global_position
	
		

func _on_waves_timeout():
	Variables.wave += 1
	
func spawnline(scene):
	$spawnline/PathFollow2D.progress_ratio = 0
	var s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	$spawnline/PathFollow2D.progress_ratio = 0.25
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	$spawnline/PathFollow2D.progress_ratio = 0.5
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	$spawnline/PathFollow2D.progress_ratio = 0.75
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	$spawnline/PathFollow2D.progress_ratio = 1
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	
func spawnv(scene):
	$spawnline/PathFollow2D.progress_ratio = 0.5
	var s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	await get_tree().create_timer(0.5).timeout
	$spawnline/PathFollow2D.progress_ratio = 0.25
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	$spawnline/PathFollow2D.progress_ratio = 0.75
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	await get_tree().create_timer(0.5).timeout
	$spawnline/PathFollow2D.progress_ratio = 0
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
	$spawnline/PathFollow2D.progress_ratio = 1
	s = scene.instantiate()
	get_tree().get_root().add_child(s)
	s.global_position = $spawnline/PathFollow2D.global_position
