extends StaticBody2D
var window_height
var player_height
@export var SPEED = 1000.0


func _ready():
	window_height = get_viewport_rect().size.y
	player_height = $ColorRect.get_size().y - 65

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += SPEED * delta
	position.y = clamp( position.y,player_height/2 , window_height - player_height/2 )
