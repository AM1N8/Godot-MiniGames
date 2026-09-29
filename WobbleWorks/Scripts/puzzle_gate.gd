extends AnimatableBody3D

## A gate that opens when ALL linked pressure plates are pressed simultaneously.
## Assign pressure plate nodes via the exported array.

@export var open_offset: Vector3 = Vector3(0, 5.0, 0)
@export var open_speed: float = 3.0
@export var plate_paths: Array[NodePath] = []

var closed_position: Vector3
var open_position: Vector3
var is_open: bool = false
var plate_states: Dictionary = {}

func _ready():
	closed_position = global_position
	open_position = closed_position + open_offset

	# Connect to each pressure plate's signal
	for path in plate_paths:
		var plate = get_node_or_null(path)
		if plate and plate.has_signal("pressed_state_changed"):
			plate_states[path] = false
			plate.pressed_state_changed.connect(_on_plate_changed.bind(path))

func _physics_process(delta):
	var target = open_position if is_open else closed_position
	global_position = global_position.lerp(target, open_speed * delta)

func _on_plate_changed(pressed: bool, path: NodePath):
	plate_states[path] = pressed
	# Open only if ALL plates are pressed
	var all_pressed = true
	for key in plate_states:
		if not plate_states[key]:
			all_pressed = false
			break
	is_open = all_pressed
