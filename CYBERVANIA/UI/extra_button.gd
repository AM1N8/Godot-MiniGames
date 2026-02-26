extends Sprite2D


func _input(event):
 if Input.is_action_just_pressed("BUTTON_LEFT"):
  if get_rect().has_point(to_local(event.position)):
   print("You clicked on Sprite!")


