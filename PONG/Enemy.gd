extends StaticBody2D

var ball_pos : Vector2
var move_by
var dist
var window_height
var player_height
var SPEED = Global.P2speed


func _ready():
	window_height = get_viewport_rect().size.y
	player_height = $ColorRect2.get_size().y - 65
	
func _physics_process(delta):
	ball_pos = $"../BALL".position
	dist = position.y - ball_pos.y
	if abs(dist) > SPEED*delta :
		move_by = SPEED * delta * (dist/abs(dist))
	else :
		move_by = dist
	position.y -= move_by
	position.y = clamp( position.y,player_height/2 , window_height - player_height/2 )
