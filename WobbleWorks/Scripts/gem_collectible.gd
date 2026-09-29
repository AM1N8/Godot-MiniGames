extends Area3D

## Unique ID for this gem (0, 1, 2). Set in inspector or scene.
@export var gem_id: int = 0

## The color of this gem's glow light and mesh tint.
@export var gem_color: Color = Color(1, 0.3, 0.8)

var collected: bool = false

@onready var indicator_mesh: MeshInstance3D = $IndicatorMesh

func _ready():
	body_entered.connect(_on_body_entered)

	# Apply gem color to the mesh material
	if indicator_mesh:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = gem_color
		mat.emission_enabled = true
		mat.emission = gem_color
		mat.emission_energy_multiplier = 3.0
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color.a = 0.85
		indicator_mesh.material_override = mat

func _process(_delta):
	if not collected and indicator_mesh:
		# Gentle float & spin animation
		indicator_mesh.rotation.y += _delta * 2.0
		indicator_mesh.position.y = sin(Time.get_ticks_msec() * 0.002) * 0.15

func _on_body_entered(body: Node3D):
	if collected:
		return

	# Check if the body is a player bone
	var is_player = false
	var parent = body
	while parent != null:
		if parent.name == "Character":
			is_player = true
			break
		parent = parent.get_parent()

	if is_player:
		collected = true
		# Hide the gem visually
		if indicator_mesh:
			indicator_mesh.visible = false
		# Disable further collisions
		set_deferred("monitoring", false)
		# Notify the gem manager
		var manager = _find_gem_manager()
		if manager:
			manager.collect_gem(gem_id)

func _find_gem_manager() -> Node:
	# Walk up the tree to find the GemManager node
	var node = get_tree().root
	var managers = node.find_children("GemManager", "", true, false)
	if managers.size() > 0:
		return managers[0]
	return null
