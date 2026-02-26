extends CanvasLayer

func _process(delta):
	if Global.CRT:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
