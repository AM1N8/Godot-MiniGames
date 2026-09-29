extends Node3D

## Builds the entire Gem Temple level procedurally at runtime.
## Attach this to the root node of gem_temple.tscn.

const CHARACTER_SCENE = preload("res://Scenes/character.tscn")

var gem_manager: Node

func _ready():
	_build_environment()
	_spawn_player()
	_build_hub()
	_build_puzzle_1()
	_build_puzzle_2()
	_build_puzzle_3()
	_build_hud()
	_build_checkpoints()

# ─── Helpers ───

func _box(parent: Node3D, pos: Vector3, size: Vector3, mat: StandardMaterial3D) -> CSGBox3D:
	var b = CSGBox3D.new()
	b.position = pos
	b.size = size
	b.use_collision = true
	b.material = mat
	parent.add_child(b)
	return b

func _crate(parent: Node3D, pos: Vector3, size: float, mass_val: float, mat: StandardMaterial3D) -> RigidBody3D:
	var rb = RigidBody3D.new()
	rb.position = pos
	rb.mass = mass_val
	var pm = PhysicsMaterial.new()
	pm.friction = 0.8
	rb.physics_material_override = pm
	var col = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(size, size, size)
	col.shape = shape
	rb.add_child(col)
	var mesh = MeshInstance3D.new()
	var bmesh = BoxMesh.new()
	bmesh.size = Vector3(size, size, size)
	mesh.mesh = bmesh
	mesh.material_override = mat
	rb.add_child(mesh)
	parent.add_child(rb)
	return rb

func _plate(parent: Node3D, pos: Vector3) -> Area3D:
	var plate = Area3D.new()
	plate.position = pos
	# Build all children BEFORE setting script and adding to tree
	# Collision
	var col = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(2.0, 0.4, 2.0)
	col.shape = shape
	plate.add_child(col)
	# Base mesh
	var base = CSGBox3D.new()
	base.size = Vector3(2.0, 0.1, 2.0)
	base.position = Vector3(0, -0.15, 0)
	base.use_collision = true
	var base_mat = StandardMaterial3D.new()
	base_mat.albedo_color = Color(0.3, 0.3, 0.35)
	base.material = base_mat
	plate.add_child(base)
	# Button mesh (the part that depresses) — name must match $ButtonMesh in pressure_plate.gd
	var btn = MeshInstance3D.new()
	btn.name = "ButtonMesh"
	var btn_mesh = BoxMesh.new()
	btn_mesh.size = Vector3(1.6, 0.15, 1.6)
	btn.mesh = btn_mesh
	var btn_mat = StandardMaterial3D.new()
	btn_mat.albedo_color = Color(0.9, 0.2, 0.2)
	btn_mat.emission_enabled = true
	btn_mat.emission = Color(0.9, 0.2, 0.2)
	btn_mat.emission_energy_multiplier = 0.5
	btn.material_override = btn_mat
	plate.add_child(btn)
	# Now attach script and add to tree so _ready() finds ButtonMesh
	plate.set_script(load("res://Scripts/pressure_plate.gd"))
	parent.add_child(plate)
	return plate

func _gem(parent: Node3D, pos: Vector3, id: int, color: Color) -> Area3D:
	var gem = Area3D.new()
	gem.position = pos
	# Build children BEFORE script/tree so @onready $IndicatorMesh resolves
	# Collision
	var col = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 1.2
	col.shape = shape
	gem.add_child(col)
	# Mesh
	var mesh = MeshInstance3D.new()
	mesh.name = "IndicatorMesh"
	var pmesh = PrismMesh.new()
	pmesh.size = Vector3(0.6, 0.8, 0.6)
	mesh.mesh = pmesh
	gem.add_child(mesh)
	# Light
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 4.0
	light.omni_range = 6.0
	light.position = Vector3(0, 0.5, 0)
	gem.add_child(light)
	# Attach script and add to tree last
	gem.set_script(load("res://Scripts/gem_collectible.gd"))
	gem.set("gem_id", id)
	gem.set("gem_color", color)
	parent.add_child(gem)
	return gem

func _mat(color: Color) -> StandardMaterial3D:
	var m = StandardMaterial3D.new()
	m.albedo_color = color
	return m

func _mat_tex(path: String) -> StandardMaterial3D:
	var m = StandardMaterial3D.new()
	var tex = load(path)
	if tex:
		m.albedo_texture = tex
		m.uv1_scale = Vector3(0.25, 0.25, 0.25)
		m.uv1_triplanar = true
	return m

# ─── Environment ───

func _build_environment():
	# Sky
	var sky_mat = load("res://Resources/sky.tres")
	var sky = Sky.new()
	sky.sky_material = sky_mat
	var env = Environment.new()
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.tonemap_mode = 2
	env.glow_enabled = true
	env.glow_intensity = 0.6
	env.glow_bloom = 0.15
	var we = WorldEnvironment.new()
	we.environment = env
	add_child(we)
	# Light
	var dl = DirectionalLight3D.new()
	dl.transform = Transform3D(Basis(Vector3(1,0,0), -PI/4) * Basis(Vector3(0,1,0), PI/6), Vector3(0, 15, 0))
	dl.shadow_enabled = true
	dl.shadow_bias = 0.04
	dl.light_energy = 1.1
	add_child(dl)

func _spawn_player():
	var player = CHARACTER_SCENE.instantiate()
	player.position = Vector3(0, 3, 0)
	add_child(player)

# ─── Hub Area (center) ───

func _build_hub():
	var floor_mat = _mat_tex("res://Assets/godot-prototype-texture/PNG/checker_black_512x512.png")
	var wall_mat = _mat_tex("res://Assets/godot-prototype-texture/PNG/grid_blue_512x512.png")

	# Main floor
	_box(self, Vector3(0, -0.5, 0), Vector3(80, 1, 80), floor_mat)

	# Perimeter walls
	_box(self, Vector3(0, 2, -40), Vector3(80, 4, 1), wall_mat)
	_box(self, Vector3(0, 2, 40), Vector3(80, 4, 1), wall_mat)
	_box(self, Vector3(-40, 2, 0), Vector3(1, 4, 80), wall_mat)
	_box(self, Vector3(40, 2, 0), Vector3(1, 4, 80), wall_mat)

	# Hub signpost pillars — mark directions to each puzzle
	var pillar_mat = _mat(Color(0.2, 0.2, 0.3))
	_box(self, Vector3(-4, 1.5, -4), Vector3(0.6, 3, 0.6), pillar_mat)
	_box(self, Vector3(4, 1.5, -4), Vector3(0.6, 3, 0.6), pillar_mat)
	_box(self, Vector3(0, 1.5, 4), Vector3(0.6, 3, 0.6), pillar_mat)

# ─── Puzzle 1: Weight Plates (North-West) ───
# Push 2 crates onto 2 pressure plates to open a gate. Gem is behind the gate.

func _build_puzzle_1():
	var zone = Node3D.new()
	zone.name = "Puzzle1_WeightPlates"
	zone.position = Vector3(-24, 0, -24)
	add_child(zone)

	var stone_mat = _mat(Color(0.35, 0.3, 0.25))
	var gate_mat = _mat(Color(0.5, 0.15, 0.15))
	var crate_mat = _mat_tex("res://Assets/godot-prototype-texture/PNG/checker_orange_512x512.png")

	# Puzzle arena walls
	_box(zone, Vector3(0, 1.5, -6), Vector3(14, 3, 0.5), stone_mat)
	_box(zone, Vector3(-7, 1.5, 0), Vector3(0.5, 3, 12), stone_mat)
	_box(zone, Vector3(7, 1.5, 0), Vector3(0.5, 3, 12), stone_mat)

	# Back wall with gap for gate
	_box(zone, Vector3(-4.5, 1.5, 6), Vector3(5, 3, 0.5), stone_mat)
	_box(zone, Vector3(4.5, 1.5, 6), Vector3(5, 3, 0.5), stone_mat)

	# Two pressure plates
	var plate1 = _plate(zone, Vector3(-3, 0.1, 0))
	var plate2 = _plate(zone, Vector3(3, 0.1, 0))

	# Gate (opens upward when both plates pressed)
	var gate = AnimatableBody3D.new()
	gate.name = "Gate1"
	gate.position = Vector3(0, 1.5, 6)
	gate.set_script(load("res://Scripts/puzzle_gate.gd"))
	gate.set("open_offset", Vector3(0, 4, 0))
	zone.add_child(gate)
	# We need to set plate_paths after adding to tree
	var gate_col = CollisionShape3D.new()
	var gate_shape = BoxShape3D.new()
	gate_shape.size = Vector3(4, 3, 0.5)
	gate_col.shape = gate_shape
	gate.add_child(gate_col)
	var gate_mesh = MeshInstance3D.new()
	var gate_bmesh = BoxMesh.new()
	gate_bmesh.size = Vector3(4, 3, 0.5)
	gate_mesh.mesh = gate_bmesh
	gate_mesh.material_override = gate_mat
	gate.add_child(gate_mesh)

	# Connect plates to gate after tree is ready
	var gate_paths: Array[NodePath] = [
		gate.get_path_to(plate1),
		gate.get_path_to(plate2),
	]
	gate.plate_paths = gate_paths

	# Two pushable crates (placed away from plates so player must push them)
	_crate(zone, Vector3(-3, 1, -4), 1.5, 5.0, crate_mat)
	_crate(zone, Vector3(3, 1, -4), 1.5, 5.0, crate_mat)

	# Gem room behind gate
	_box(zone, Vector3(0, 0, 10), Vector3(6, 0.2, 4), stone_mat)
	_gem(zone, Vector3(0, 1.5, 10), 0, Color(1, 0.25, 0.25))  # Ruby

# ─── Puzzle 2: Platforming Gauntlet (North-East) ───
# Cross moving platforms over a gap to reach the gem on a floating island.

func _build_puzzle_2():
	var zone = Node3D.new()
	zone.name = "Puzzle2_Platforming"
	zone.position = Vector3(24, 0, -24)
	add_child(zone)

	var stone_mat = _mat(Color(0.25, 0.35, 0.25))
	var plat_mat = _mat_tex("res://Assets/godot-prototype-texture/PNG/checker_cyan_512x512.png")

	# Start platform
	_box(zone, Vector3(0, 2, 0), Vector3(4, 0.5, 4), stone_mat)

	# Ramp up to start platform
	var ramp = CSGBox3D.new()
	ramp.size = Vector3(3, 0.4, 5)
	ramp.position = Vector3(0, 0.8, 3.5)
	ramp.rotation.x = deg_to_rad(-20)
	ramp.use_collision = true
	ramp.material = stone_mat
	zone.add_child(ramp)

	# Moving platform 1
	var mp1 = AnimatableBody3D.new()
	mp1.position = Vector3(0, 2, -5)
	mp1.set_script(load("res://Scripts/moving_platform.gd"))
	mp1.set("travel_offset", Vector3(5, 0, 0))
	zone.add_child(mp1)
	var mp1_mesh = CSGBox3D.new()
	mp1_mesh.size = Vector3(3, 0.5, 3)
	mp1_mesh.material = plat_mat
	mp1.add_child(mp1_mesh)
	var mp1_col = CollisionShape3D.new()
	var mp1_shape = BoxShape3D.new()
	mp1_shape.size = Vector3(3, 0.5, 3)
	mp1_col.shape = mp1_shape
	mp1.add_child(mp1_col)

	# Stepping stone
	_box(zone, Vector3(0, 3, -10), Vector3(2.5, 0.5, 2.5), stone_mat)

	# Moving platform 2 (goes up and down)
	var mp2 = AnimatableBody3D.new()
	mp2.position = Vector3(0, 3, -15)
	mp2.set_script(load("res://Scripts/moving_platform.gd"))
	mp2.set("travel_offset", Vector3(0, 3, 0))
	zone.add_child(mp2)
	var mp2_mesh = CSGBox3D.new()
	mp2_mesh.size = Vector3(3, 0.5, 3)
	mp2_mesh.material = plat_mat
	mp2.add_child(mp2_mesh)
	var mp2_col = CollisionShape3D.new()
	var mp2_shape = BoxShape3D.new()
	mp2_shape.size = Vector3(3, 0.5, 3)
	mp2_col.shape = mp2_shape
	mp2.add_child(mp2_col)

	# Gem island
	_box(zone, Vector3(0, 5.5, -20), Vector3(4, 0.5, 4), stone_mat)
	_gem(zone, Vector3(0, 7, -20), 1, Color(0.25, 1, 0.35))  # Emerald

# ─── Puzzle 3: Stacking Climb (South) ───
# Stack crates to climb to a high ledge where the gem sits.

func _build_puzzle_3():
	var zone = Node3D.new()
	zone.name = "Puzzle3_Stacking"
	zone.position = Vector3(0, 0, 28)
	add_child(zone)

	var stone_mat = _mat(Color(0.25, 0.25, 0.4))
	var crate_mat = _mat_tex("res://Assets/godot-prototype-texture/PNG/checker_yellow_512x512.png")

	# Arena walls
	_box(zone, Vector3(-6, 1.5, 0), Vector3(0.5, 3, 14), stone_mat)
	_box(zone, Vector3(6, 1.5, 0), Vector3(0.5, 3, 14), stone_mat)
	_box(zone, Vector3(0, 1.5, -7), Vector3(12, 3, 0.5), stone_mat)

	# High pedestal where gem sits — too high to jump to directly
	var pedestal = _box(zone, Vector3(0, 3.5, -5), Vector3(3, 7, 3), stone_mat)

	# Several crates to stack
	_crate(zone, Vector3(-3, 1, 3), 1.6, 4.0, crate_mat)
	_crate(zone, Vector3(0, 1, 4), 1.6, 4.0, crate_mat)
	_crate(zone, Vector3(3, 1, 3), 1.6, 4.0, crate_mat)
	_crate(zone, Vector3(-1.5, 1, 6), 1.6, 4.0, crate_mat)

	# A small step to help initial climbing
	_box(zone, Vector3(3, 0.5, -3), Vector3(2, 1, 2), stone_mat)

	# Gem on top of pedestal
	_gem(zone, Vector3(0, 8.5, -5), 2, Color(0.25, 0.5, 1))  # Sapphire

# ─── HUD (controls panel, bottom-left) ───

func _build_hud():
	# Gem manager
	gem_manager = Node.new()
	gem_manager.name = "GemManager"
	gem_manager.set_script(load("res://Scripts/gem_manager.gd"))
	add_child(gem_manager)

	# Controls panel
	var canvas = $CanvasLayer
	var panel = PanelContainer.new()
	panel.offset_left = 20
	panel.offset_top = 20
	panel.offset_right = 280
	panel.offset_bottom = 230
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.75)
	style.set_corner_radius_all(10)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.3, 0.4, 0.6, 0.4)
	style.shadow_color = Color(0, 0, 0, 0.3)
	style.shadow_size = 5
	panel.add_theme_stylebox_override("panel", style)
	canvas.add_child(panel)
	var margin = MarginContainer.new()
	margin.layout_mode = 2
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)
	var lbl = Label.new()
	lbl.layout_mode = 2
	lbl.add_theme_color_override("font_color", Color(0.9, 0.9, 0.95))
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.text = "GEM TEMPLE CONTROLS:\n• Move: W / A / S / D\n• Jump: Space\n• Grab Left: Left Click\n• Grab Right: Right Click\n• Toggle Ragdoll: R\n• Free Mouse: Esc\n\nCollect all 3 gems to win!"
	margin.add_child(lbl)

# ─── Checkpoints ───

func _build_checkpoints():
	var cp_script = load("res://Scripts/checkpoint_trigger.gd")
	var positions = [
		Vector3(-24, 0.1, -18),  # Near puzzle 1
		Vector3(24, 0.1, -18),   # Near puzzle 2
		Vector3(0, 0.1, 22),     # Near puzzle 3
	]
	for pos in positions:
		var cp = Area3D.new()
		cp.position = pos
		# Build children before script/tree
		var col = CollisionShape3D.new()
		var shape = SphereShape3D.new()
		shape.radius = 3.0
		col.shape = shape
		cp.add_child(col)
		var mesh = MeshInstance3D.new()
		mesh.name = "IndicatorMesh"
		var smesh = SphereMesh.new()
		smesh.radius = 0.3
		smesh.height = 0.6
		mesh.mesh = smesh
		mesh.position = Vector3(0, 1, 0)
		cp.add_child(mesh)
		cp.set_script(cp_script)
		cp.add_to_group("checkpoints")
		add_child(cp)
