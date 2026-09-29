extends AnimatableBody3D

@export var travel_offset: Vector3 = Vector3(0, 0, 5.0)
@export var duration: float = 4.0 # Time in seconds to travel to target and back

var start_pos: Vector3
var time_passed: float = 0.0

func _ready():
	start_pos = global_position

func _physics_process(delta):
	time_passed += delta
	# Use cosine wave to oscillate smoothly between 0 and 1
	var factor = (cos((time_passed / duration) * 2.0 * PI) + 1.0) / 2.0
	global_position = start_pos + travel_offset * factor
