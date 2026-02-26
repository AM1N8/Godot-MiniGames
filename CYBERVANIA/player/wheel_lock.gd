extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Variables.wheel_on and Variables.wheel_nbr == 1:
		if Variables.wheel_on:
			$death_wheel.visible = true
			$death_wheel.monitoring = true
		else:
			$death_wheel.visible = false
			$death_wheel.monitoring = false
	elif Variables.wheel_on and Variables.wheel_nbr == 2:
		if Variables.wheel_on:
			$death_wheel2.visible = true
			$death_wheel2.monitoring = true
		else:
			$death_wheel2.visible = false
			$death_wheel2.monitoring = false
	elif Variables.wheel_on and Variables.wheel_nbr == 3:
		if Variables.wheel_on:
			$death_wheel3.visible = true
			$death_wheel3.monitoring = true
		else:
			$death_wheel3.visible = false
			$death_wheel3.monitoring = false
	elif Variables.wheel_on and Variables.wheel_nbr >= 4:
		if Variables.wheel_on:
			$death_wheel4.visible = true
			$death_wheel4.monitoring = true
		else:
			$death_wheel4.visible = false
			$death_wheel4.monitoring = false	
	else:
		$death_wheel.visible = false
		$death_wheel.monitoring = false
		$death_wheel2.visible = false
		$death_wheel2.monitoring = false
		$death_wheel3.visible = false
		$death_wheel3.monitoring = false
		$death_wheel4.visible = false
		$death_wheel4.monitoring = false
