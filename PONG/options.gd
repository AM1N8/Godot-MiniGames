extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")


func _on_easy_pressed():
	Global.P2speed = 400
	$"skill issue/AnimationPlayer".play("move")
func _on_normal_pressed():
	Global.P2speed = 500
func _on_impossible_pressed():
	Global.P2speed = 600
func _on_check_button_toggled(toggled_on):
	Global.fullscreen = !Global.fullscreen
	_ready()


func _on_check_button_2_toggled(toggled_on):
	Global.CRT = !Global.CRT


