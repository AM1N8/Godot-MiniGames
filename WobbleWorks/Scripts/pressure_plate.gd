extends Area3D

signal pressed_state_changed(is_pressed: bool)

@export var press_depth: float = 0.15
@export var press_speed: float = 5.0
@export var target_door: NodePath

var original_pos: Vector3
var target_pos: Vector3
var is_pressed: bool = false
var active_bodies: Array[Node3D] = []

@onready var button_mesh = $ButtonMesh

func _ready():
	original_pos = button_mesh.position
	target_pos = original_pos - Vector3(0, press_depth, 0)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta):
	# Smoothly animate the button going down or up
	var dest = target_pos if is_pressed else original_pos
	button_mesh.position = button_mesh.position.lerp(dest, press_speed * delta)

func _on_body_entered(body: Node3D):
	if body is PhysicsBody3D and body.get_parent() != self:
		if not active_bodies.has(body):
			active_bodies.append(body)
			if not is_pressed:
				is_pressed = true
				pressed_state_changed.emit(true)
				_notify_door(true)

func _on_body_exited(body: Node3D):
	if active_bodies.has(body):
		active_bodies.erase(body)
		if active_bodies.is_empty() and is_pressed:
			is_pressed = false
			pressed_state_changed.emit(false)
			_notify_door(false)

func _notify_door(state: bool):
	if target_door:
		var door_node = get_node(target_door)
		if door_node and door_node.has_method("set_open"):
			door_node.set_open(state)
