extends Area3D

var won: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if won:
		return
	
	# Check if the body belongs to the player character
	# The active ragdoll bones are children of Skeleton3D, which is inside Armature, inside Physical, etc.
	# Or the main body is 'Physical Bone Body'
	var is_player = false
	var parent = body
	while parent != null:
		if parent.name == "Character" or parent.name == "World":
			if parent.name == "Character":
				is_player = true
			break
		parent = parent.get_parent()
		
	if is_player:
		won = true
		show_victory_screen()

func show_victory_screen():
	# Capture mouse to allow clicking restart
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Create CanvasLayer for UI
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Root control node
	var root = ColorRect.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Premium semi-transparent dark background for glassmorphism feel
	root.color = Color(0.08, 0.08, 0.1, 0.7)
	canvas_layer.add_child(root)
	
	# Panel container for the card
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(450, 300)
	panel.anchors_preset = Control.PRESET_CENTER
	# Center it
	root.add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	# Add custom stylebox override for sleek premium glass panel
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.15, 0.15, 0.22, 0.85)
	stylebox.border_width_left = 2
	stylebox.border_width_right = 2
	stylebox.border_width_top = 2
	stylebox.border_width_bottom = 2
	stylebox.border_color = Color(0.3, 0.5, 0.9, 0.6) # Sleek blue accent border
	stylebox.corner_radius_top_left = 16
	stylebox.corner_radius_top_right = 16
	stylebox.corner_radius_bottom_left = 16
	stylebox.corner_radius_bottom_right = 16
	stylebox.shadow_color = Color(0, 0, 0, 0.4)
	stylebox.shadow_size = 30
	panel.add_theme_stylebox_override("panel", stylebox)
	
	# VBoxContainer for layout
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(vbox)
	
	# Add padding
	var padding = MarginContainer.new()
	padding.add_theme_constant_override("margin_left", 32)
	padding.add_theme_constant_override("margin_right", 32)
	padding.add_theme_constant_override("margin_top", 32)
	padding.add_theme_constant_override("margin_bottom", 32)
	panel.add_child(padding)
	
	var inner_vbox = VBoxContainer.new()
	inner_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	inner_vbox.add_theme_constant_override("separation", 20)
	padding.add_child(inner_vbox)
	
	# Title Label
	var title = Label.new()
	title.text = "VICTORY!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Style the title text
	var title_font_size = 42
	title.add_theme_font_size_override("font_size", title_font_size)
	title.add_theme_color_override("font_color", Color(0.3, 0.7, 1.0)) # Bright cyan
	inner_vbox.add_child(title)
	
	# Subtitle Label
	var subtitle = Label.new()
	subtitle.text = "You successfully navigated the physical challenges!"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.8, 0.8, 0.85))
	inner_vbox.add_child(subtitle)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	inner_vbox.add_child(spacer)
	
	# Restart Button
	var btn_restart = Button.new()
	btn_restart.text = "Play Again"
	btn_restart.custom_minimum_size = Vector2(200, 48)
	btn_restart.add_theme_font_size_override("font_size", 18)
	
	# Button styling
	var btn_normal = StyleBoxFlat.new()
	btn_normal.bg_color = Color(0.18, 0.38, 0.8)
	btn_normal.corner_radius_top_left = 8
	btn_normal.corner_radius_top_right = 8
	btn_normal.corner_radius_bottom_left = 8
	btn_normal.corner_radius_bottom_right = 8
	
	var btn_hover = StyleBoxFlat.new()
	btn_hover.bg_color = Color(0.25, 0.48, 0.95)
	btn_hover.corner_radius_top_left = 8
	btn_hover.corner_radius_top_right = 8
	btn_hover.corner_radius_bottom_left = 8
	btn_hover.corner_radius_bottom_right = 8
	
	btn_restart.add_theme_stylebox_override("normal", btn_normal)
	btn_restart.add_theme_stylebox_override("hover", btn_hover)
	btn_restart.add_theme_stylebox_override("pressed", btn_normal)
	
	btn_restart.pressed.connect(_on_restart_pressed)
	inner_vbox.add_child(btn_restart)
	
	# Main Menu Button
	var btn_menu = Button.new()
	btn_menu.text = "Main Menu"
	btn_menu.custom_minimum_size = Vector2(200, 48)
	btn_menu.add_theme_font_size_override("font_size", 18)
	
	btn_menu.add_theme_stylebox_override("normal", btn_normal)
	btn_menu.add_theme_stylebox_override("hover", btn_hover)
	btn_menu.add_theme_stylebox_override("pressed", btn_normal)
	
	btn_menu.pressed.connect(func():
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	)
	inner_vbox.add_child(btn_menu)
	
	# Focus grab
	btn_restart.grab_focus()

func _on_restart_pressed():
	get_tree().reload_current_scene()
