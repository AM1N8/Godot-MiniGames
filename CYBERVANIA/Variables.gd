extends Node

@export var eyeball_damage = 1
@export var player_speed = 300
@export var exp_value = 0
@export var bullet_time = 3
@export var health = 50
@export var full_health = 50
var wheel_on = false
var score = 0
var shake = false
var shield_on = false
var wheel_nbr = 1
var shield_scale = 1
var is_dead = false

func RESTART():
	eyeball_damage = 1
	player_speed = 300
	exp_value = 0
	bullet_time = 3
	health = 50
	full_health = 50
	wheel_on = false
	score = 0
	shake = false
	shield_on = false
	shield_scale = 1
	is_dead = false
