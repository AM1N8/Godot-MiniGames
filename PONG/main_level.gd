extends Node2D

var score = [0,0]
func _ready():
	if Global.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$start_music.play()

func _on_ball_timer_timeout():
	$BALL.NewBall()


func _on_right_goal_body_entered(body):
	score[0] += 1 
	$"player 1/AnimationPlayer".play("win")
	$score/left_score.text = str(score[0]) 
	$BallTimer.start()
	$BALL.SPEED = 500
	

func _on_left_goal_body_entered(body):
	score[1] +=1
	$Enemy/AnimationPlayer.play("win")
	$score/right_score.text = str(score[1]) 
	$BallTimer.start()
	$BALL.SPEED = 500



func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")
