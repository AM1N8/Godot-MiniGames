extends VisibleOnScreenNotifier2D


func _on_screen_exited():
	queue_free()
