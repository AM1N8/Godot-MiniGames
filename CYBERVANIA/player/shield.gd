extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Shield.rotate(PI/100)
	$".".scale = Vector2(Variables.shield_scale,Variables.shield_scale)
	if Variables.shield_on:
		$".".visible = true
		$".".monitoring = true
	else:
		$".".visible = false
		$".".monitoring = false


func _on_body_entered(body):
	if body.has_method("passive_in"):
		body.passive_in()
		
func _on_body_exited(body):
	if body.has_method("passive_out"):
		body.passive_out()
