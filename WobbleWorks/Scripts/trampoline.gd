extends Area3D

@export var launch_force: float = 18.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	var parent = body
	var player = null
	while parent != null:
		if parent.name == "Character":
			player = parent
			break
		parent = parent.get_parent()
		
	if player:
		# Play a fun squash/stretch effect if we want, or just apply the physics impulse
		# Set y component of linear velocity to launch the player
		if "physical_bone_body" in player and player.physical_bone_body:
			player.physical_bone_body.linear_velocity.y = launch_force
		if "physics_bones" in player and player.physics_bones:
			for b in player.physics_bones:
				b.linear_velocity.y = launch_force
				
		# Visual spring bounce effect (animate local scale briefly)
		var tween = create_tween()
		tween.tween_property(self, "scale:y", 0.4, 0.05)
		tween.tween_property(self, "scale:y", 1.2, 0.08)
		tween.tween_property(self, "scale:y", 1.0, 0.15)
