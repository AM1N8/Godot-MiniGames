extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://tester.tscn")
	


func _on_quit_pressed():
	get_tree().quit()
