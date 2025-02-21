extends CharacterBody2D

var window_size : Vector2
@export var SPEED = 500.0
@export var acceleration = 50
var dir : Vector2
var MAX_Y = 0.6

func _ready():
	window_size = get_viewport_rect().size
	
func NewBall():
	position.x = window_size.x/2
	position.y = randi_range(200,window_size.y-200)
	dir = random_direction()
	
func random_direction():
	var NewDir : Vector2
	NewDir.x = [-1,1].pick_random()
	NewDir.y= randf_range(-1,1)
	return NewDir.normalized()
	
func _physics_process(delta):
	var collision = move_and_collide(dir * SPEED * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		if collider == $"../player 1" or collider == $"../Enemy":
			SPEED += acceleration
			dir = rand_direction(collider)
			$"../hit_sfx".play()
		else:
			dir = dir.bounce(collision.get_normal())
func rand_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var newdir : Vector2
	if dir.x > 0:
		newdir.x = -1
	else:
		newdir.x = 1
	newdir.y = (dist/(collider.player_height/2))*MAX_Y
	return newdir.normalized()
