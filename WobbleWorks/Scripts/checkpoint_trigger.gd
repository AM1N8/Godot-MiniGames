extends Area3D

@export var active_color: Color = Color(0.2, 1.0, 0.4, 0.8)
@export var inactive_color: Color = Color(1.0, 0.2, 0.2, 0.4)

var is_active: bool = false
@onready var indicator_mesh: MeshInstance3D = $IndicatorMesh

func _ready():
	body_entered.connect(_on_body_entered)
	_update_indicator()

func _on_body_entered(body: Node3D):
	# If this is already the active checkpoint, ignore
	var parent = body
	var player = null
	while parent != null:
		if parent.name == "Character":
			player = parent
			break
		parent = parent.get_parent()
		
	if player:
		# Deactivate all other checkpoints
		for node in get_tree().get_nodes_in_group("checkpoints"):
			if node != self and node.has_method("deactivate"):
				node.deactivate()
				
		is_active = true
		player.set_checkpoint(global_position + Vector3(0, 1.5, 0))
		_update_indicator()

func deactivate():
	is_active = false
	_update_indicator()

func _update_indicator():
	if indicator_mesh:
		var mat = indicator_mesh.get_surface_override_material(0)
		if not mat:
			mat = StandardMaterial3D.new()
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			indicator_mesh.set_surface_override_material(0, mat)
		mat.albedo_color = active_color if is_active else inactive_color
		mat.emission_enabled = true
		mat.emission = active_color if is_active else inactive_color
		mat.emission_energy_multiplier = 2.0 if is_active else 0.5
