extends Area2D

var dmg = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(PI/36)


func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(dmg)
