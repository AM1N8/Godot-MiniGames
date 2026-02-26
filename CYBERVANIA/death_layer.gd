extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$score_nbr.text = str(Variables.score)
	if Variables.is_dead:
		visible = true


func _on_replay_pressed():
	get_tree().paused = false
	self.visible = false
	Variables.RESTART()
	get_tree().reload_current_scene()


func _on_menu_pressed():
	get_tree().paused = false
	self.visible = false
	Variables.RESTART()
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
