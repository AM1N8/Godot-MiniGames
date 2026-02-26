extends CanvasLayer

var level = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar/lvl/nbr.text = str(level)
	$Health.max_value = Variables.full_health
	$Health.value = Variables.health
	$ProgressBar.value = Variables.exp_value
	$score_nbr.text = str(Variables.score)
	
	if $ProgressBar.value >= $ProgressBar.max_value:
		upgrade()
		

func _on_bullet_pressed():
	Variables.bullet_time *= 0.5
	Variables.health = Variables.full_health
	get_tree().paused = false
	$Board.visible = false


func _on_speed_pressed():
	Variables.player_speed *= 1.5
	Variables.health = Variables.full_health
	get_tree().paused = false
	$Board.visible = false


func _on_health_pressed():
	Variables.full_health *= 1.5
	Variables.health = Variables.full_health
	get_tree().paused = false
	$Board.visible = false

func upgrade():
	level += 1
	Variables.exp_value = 0
	
	$Board.visible = true
	get_tree().paused = true
	$ProgressBar.max_value = $ProgressBar.max_value * 2


func _on_pause_pressed():
	
	get_tree().paused = !get_tree().paused
