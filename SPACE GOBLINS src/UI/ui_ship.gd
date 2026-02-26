extends CanvasLayer
func _ready():
	$TextureProgressBar.value = $TextureProgressBar.max_value
	$TextureProgressBar.scale = Vector2(2,2)
	$stamina.value = Variables.stamina
	
func _physics_process(delta):
	$TextureProgressBar.max_value = Variables.max_health
	$TextureProgressBar.value = Variables.health
	$stamina.value = Variables.stamina
	$score.text = str(Variables.score)
	bar_move()
	stamina_cooldown()
	play_wave()

func bar_move():
	if Variables.is_move_bar :
		$AnimationPlayer.play("hit")
		Variables.is_move_bar = false
	
func stamina_cooldown():
	if Variables.stamina > 0:
		Variables.stamina -= 0.2

func play_wave():
	$WAVE/nbr.text = str(Variables.wave)

