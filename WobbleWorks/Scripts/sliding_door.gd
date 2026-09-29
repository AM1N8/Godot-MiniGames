extends AnimatableBody3D

@export var open_offset: Vector3 = Vector3(0, 6.0, 0)
@export var open_speed: float = 3.0

var closed_position: Vector3
var open_position: Vector3
var is_open: bool = false

func _ready():
	closed_position = global_position
	open_position = closed_position + open_offset

func _physics_process(delta):
	var target = open_position if is_open else closed_position
	global_position = global_position.lerp(target, open_speed * delta)

func set_open(state: bool):
	is_open = state
