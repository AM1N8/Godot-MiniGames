extends Control

func _ready():
	if Global.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _process(delta):
	pass





func _on_options_pressed():
	get_tree().change_scene_to_file("res://options.tscn")
	


func _on_start_pressed():
	get_tree().change_scene_to_file("res://main_level.tscn")
	


func _on_quit_pressed():
	get_tree().quit()


func _on_change_color_pressed():
	
	var color = ["00eeee","e2002a","51b200","de3eff","eb6f00","ffffff"]
	$Title.modulate = color.pick_random()
