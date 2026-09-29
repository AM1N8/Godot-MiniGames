extends RigidBody3D

@export var respawn_y_threshold: float = -1.0

var start_transform: Transform3D

func _ready():
	start_transform = global_transform

func _physics_process(_delta):
	if global_position.y < respawn_y_threshold:
		# Stop all motion before resetting position
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		global_transform = start_transform
