extends Node

## Manages gem collection state and the HUD display for Level 3.
## Add this as a child node named "GemManager" in the level scene.

const TOTAL_GEMS = 3

var collected_gems: Array[bool] = [false, false, false]
var gem_count: int = 0
var victory_shown: bool = false

# HUD references (created in _ready)
var gem_labels: Array[Label] = []
var counter_label: Label

func _ready():
	_build_hud()

func collect_gem(gem_id: int):
	if gem_id < 0 or gem_id >= TOTAL_GEMS:
		return
	if collected_gems[gem_id]:
		return

	collected_gems[gem_id] = true
	gem_count += 1
	_update_hud()

	if gem_count >= TOTAL_GEMS:
		# Short delay before showing victory
		await get_tree().create_timer(1.0).timeout
		_show_victory()

func _build_hud():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	# Gem counter panel — top center
	var panel = PanelContainer.new()
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.0
	panel.anchor_bottom = 0.0
	panel.offset_left = -160
	panel.offset_right = 160
	panel.offset_top = 16
	panel.offset_bottom = 80

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.06, 0.12, 0.82)
	style.set_corner_radius_all(12)
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_color = Color(1, 1, 1, 0.08)
	style.shadow_color = Color(0, 0, 0, 0.4)
	style.shadow_size = 8
	panel.add_theme_stylebox_override("panel", style)
	canvas.add_child(panel)

	var margin = MarginContainer.new()
	margin.layout_mode = 2
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var hbox = HBoxContainer.new()
	hbox.layout_mode = 2
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 16)
	margin.add_child(hbox)

	# Gem status icons
	var gem_colors = [
		Color(1, 0.3, 0.3),   # Red
		Color(0.3, 1, 0.4),   # Green
		Color(0.3, 0.6, 1),   # Blue
	]
	var gem_names = ["Ruby", "Emerald", "Sapphire"]

	for i in range(TOTAL_GEMS):
		var lbl = Label.new()
		lbl.text = "◇ " + gem_names[i]
		lbl.add_theme_font_size_override("font_size", 16)
		lbl.add_theme_color_override("font_color", Color(0.4, 0.4, 0.5))
		hbox.add_child(lbl)
		gem_labels.append(lbl)

	# Separator
	var sep = VSeparator.new()
	hbox.add_child(sep)

	# Counter
	counter_label = Label.new()
	counter_label.text = "0 / %d" % TOTAL_GEMS
	counter_label.add_theme_font_size_override("font_size", 20)
	counter_label.add_theme_color_override("font_color", Color(1, 0.55, 0.1))
	hbox.add_child(counter_label)

func _update_hud():
	var gem_colors = [
		Color(1, 0.3, 0.3),
		Color(0.3, 1, 0.4),
		Color(0.3, 0.6, 1),
	]
	var gem_names = ["Ruby", "Emerald", "Sapphire"]

	for i in range(TOTAL_GEMS):
		if collected_gems[i]:
			gem_labels[i].text = "◆ " + gem_names[i]
			gem_labels[i].add_theme_color_override("font_color", gem_colors[i])
		else:
			gem_labels[i].text = "◇ " + gem_names[i]
			gem_labels[i].add_theme_color_override("font_color", Color(0.4, 0.4, 0.5))

	counter_label.text = "%d / %d" % [gem_count, TOTAL_GEMS]

func _show_victory():
	if victory_shown:
		return
	victory_shown = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10
	add_child(canvas_layer)

	var root = ColorRect.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.color = Color(0.05, 0.05, 0.08, 0.75)
	canvas_layer.add_child(root)

	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(480, 340)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)

	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.12, 0.12, 0.2, 0.9)
	stylebox.set_corner_radius_all(16)
	stylebox.border_width_left = 2
	stylebox.border_width_right = 2
	stylebox.border_width_top = 2
	stylebox.border_width_bottom = 2
	stylebox.border_color = Color(1, 0.55, 0.1, 0.6)
	stylebox.shadow_color = Color(0, 0, 0, 0.5)
	stylebox.shadow_size = 30
	panel.add_theme_stylebox_override("panel", stylebox)
	root.add_child(panel)

	var padding = MarginContainer.new()
	padding.add_theme_constant_override("margin_left", 36)
	padding.add_theme_constant_override("margin_right", 36)
	padding.add_theme_constant_override("margin_top", 36)
	padding.add_theme_constant_override("margin_bottom", 36)
	panel.add_child(padding)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 16)
	padding.add_child(vbox)

	var title = Label.new()
	title.text = "ALL GEMS COLLECTED!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(1, 0.55, 0.1))
	vbox.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "You solved all three puzzles and collected\nevery gem. Master wobbler!"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.8, 0.8, 0.85))
	vbox.add_child(subtitle)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer)

	# Button styles
	var btn_normal = StyleBoxFlat.new()
	btn_normal.bg_color = Color(0.18, 0.38, 0.8)
	btn_normal.set_corner_radius_all(8)
	btn_normal.content_margin_top = 12
	btn_normal.content_margin_bottom = 12

	var btn_hover = StyleBoxFlat.new()
	btn_hover.bg_color = Color(0.25, 0.48, 0.95)
	btn_hover.set_corner_radius_all(8)
	btn_hover.content_margin_top = 12
	btn_hover.content_margin_bottom = 12

	var btn_restart = Button.new()
	btn_restart.text = "Play Again"
	btn_restart.custom_minimum_size = Vector2(220, 48)
	btn_restart.add_theme_font_size_override("font_size", 18)
	btn_restart.add_theme_stylebox_override("normal", btn_normal)
	btn_restart.add_theme_stylebox_override("hover", btn_hover)
	btn_restart.add_theme_stylebox_override("pressed", btn_normal)
	btn_restart.pressed.connect(func(): get_tree().reload_current_scene())
	vbox.add_child(btn_restart)

	var btn_menu = Button.new()
	btn_menu.text = "Main Menu"
	btn_menu.custom_minimum_size = Vector2(220, 48)
	btn_menu.add_theme_font_size_override("font_size", 18)
	btn_menu.add_theme_stylebox_override("normal", btn_normal)
	btn_menu.add_theme_stylebox_override("hover", btn_hover)
	btn_menu.add_theme_stylebox_override("pressed", btn_normal)
	btn_menu.pressed.connect(func(): get_tree().change_scene_to_file("res://Scenes/main_menu.tscn"))
	vbox.add_child(btn_menu)

	btn_restart.grab_focus()
