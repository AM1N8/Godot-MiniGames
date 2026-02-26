class_name SpawnPoint
extends Node2D

@export var scene: PackedScene

func spawn(global_spawn_position: Vector2 = global_position, parent: Node = get_tree().current_scene) -> Node:
	assert(scene is PackedScene, "Error: The scene export was never set on this spawner component.")

	var instance = scene.instantiate()
	parent.add_child(instance)

	instance.global_position = global_spawn_position

	return instance
