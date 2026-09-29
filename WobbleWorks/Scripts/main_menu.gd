extends Node3D

const COL_PANEL    = Color(0.06, 0.06, 0.12, 0.88)
const COL_ACCENT   = Color(1.0, 0.55, 0.1)
const COL_ACCENT_D = Color(0.8, 0.4, 0.05)
const COL_WHITE    = Color(0.95, 0.95, 0.97)
const COL_DIM      = Color(0.5, 0.5, 0.6)
const COL_BTN      = Color(0.1, 0.1, 0.2, 0.9)
const COL_BTN_H    = Color(0.18, 0.16, 0.3, 0.95)
const COL_BTN_P    = Color(0.06, 0.06, 0.12, 0.95)

var main_panel: PanelContainer
var level_panel: PanelContainer
var options_panel: PanelContainer
var sens_slider: HSlider
var sens_label: Label

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var ui = Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$CanvasLayer.add_child(ui)
	
	main_panel = _create_main_panel()
	ui.add_child(main_panel)
	level_panel = _create_level_panel()
	ui.add_child(level_panel)
	options_panel = _create_options_panel()
	ui.add_child(options_panel)
	_show_main()

# --- Helpers ---
func _pos_center(p: PanelContainer, w: float, h: float):
	p.anchor_left = 0.5; p.anchor_right = 0.5
	p.anchor_top = 0.5; p.anchor_bottom = 0.5
	p.offset_left = -w / 2.0; p.offset_right = w / 2.0
	p.offset_top = -h / 2.0; p.offset_bottom = h / 2.0

func _style_panel() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = COL_PANEL
	s.set_corner_radius_all(16)
	s.border_width_top = 1; s.border_width_bottom = 1
	s.border_width_left = 1; s.border_width_right = 1
	s.border_color = Color(1, 1, 1, 0.06)
	s.shadow_color = Color(0, 0, 0, 0.5)
	s.shadow_size = 16
	return s

func _style_btn(c: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = c; s.set_corner_radius_all(10)
	s.content_margin_top = 14; s.content_margin_bottom = 14
	s.content_margin_left = 24; s.content_margin_right = 24
	return s

func _btn(text: String, cb: Callable, sz: int = 22) -> Button:
	var b = Button.new()
	b.text = text
	b.add_theme_stylebox_override("normal", _style_btn(COL_BTN))
	b.add_theme_stylebox_override("hover", _style_btn(COL_BTN_H))
	b.add_theme_stylebox_override("pressed", _style_btn(COL_BTN_P))
	b.add_theme_stylebox_override("focus", _style_btn(COL_BTN))
	b.add_theme_color_override("font_color", COL_WHITE)
	b.add_theme_color_override("font_hover_color", COL_ACCENT)
	b.add_theme_font_size_override("font_size", sz)
	b.pressed.connect(cb)
	return b

func _margin(node: Control, m: int = 40) -> MarginContainer:
	var mc = MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		mc.add_theme_constant_override("margin_" + side, m)
	mc.add_child(node)
	return mc

func _divider(c: Color = COL_ACCENT, h: float = 3.0) -> ColorRect:
	var d = ColorRect.new(); d.custom_minimum_size = Vector2(0, h); d.color = c
	return d

func _spacer(h: float = 20.0) -> Control:
	var sp = Control.new(); sp.custom_minimum_size.y = h; return sp

func _lbl(text: String, color: Color, size: int, center: bool = false) -> Label:
	var l = Label.new(); l.text = text
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_size_override("font_size", size)
	if center: l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l

# --- Main Panel ---
func _create_main_panel() -> PanelContainer:
	var p = PanelContainer.new()
	_pos_center(p, 400, 480)
	p.add_theme_stylebox_override("panel", _style_panel())
	var vb = VBoxContainer.new()
	vb.add_theme_constant_override("separation", 12)
	p.add_child(_margin(vb))
	vb.add_child(_lbl("PHYSICS PUZZLE PLATFORMER", COL_ACCENT, 12, true))
	vb.add_child(_lbl("WOBBLE\nWORKS", COL_WHITE, 58, true))
	vb.add_child(_divider())
	vb.add_child(_spacer(24))
	vb.add_child(_btn("S T A R T", _on_start))
	vb.add_child(_btn("O P T I O N S", _on_options))
	vb.add_child(_btn("E X I T", _on_exit))
	return p

# --- Level Panel ---
func _create_level_panel() -> PanelContainer:
	var p = PanelContainer.new()
	_pos_center(p, 420, 480)
	p.add_theme_stylebox_override("panel", _style_panel())
	var vb = VBoxContainer.new()
	vb.add_theme_constant_override("separation", 14)
	p.add_child(_margin(vb, 36))
	vb.add_child(_lbl("SELECT LEVEL", COL_ACCENT, 28, true))
	vb.add_child(_divider(COL_ACCENT_D, 2))
	vb.add_child(_spacer(8))
	vb.add_child(_btn("Level 1 :  Wobble Temple", _on_level1, 20))
	vb.add_child(_lbl("Push, climb, swing, and wobble to the summit.", COL_DIM, 13, true))
	vb.add_child(_btn("Level 2 :  Wobble Playground", _on_level2, 20))
	vb.add_child(_lbl("An open physics playground with toys to climb and ride.", COL_DIM, 13, true))
	vb.add_child(_btn("Level 3 :  Gem Temple", _on_level3, 20))
	vb.add_child(_lbl("Solve three puzzles to collect three sacred gems.", COL_DIM, 13, true))
	vb.add_child(_spacer(8))
	vb.add_child(_btn("←  B A C K", _show_main))
	return p

# --- Options Panel ---
func _create_options_panel() -> PanelContainer:
	var p = PanelContainer.new()
	_pos_center(p, 460, 500)
	p.add_theme_stylebox_override("panel", _style_panel())
	var vb = VBoxContainer.new()
	vb.add_theme_constant_override("separation", 12)
	p.add_child(_margin(vb, 36))
	vb.add_child(_lbl("OPTIONS", COL_ACCENT, 28, true))
	vb.add_child(_divider(COL_ACCENT_D, 2))
	vb.add_child(_lbl("Mouse Sensitivity", COL_WHITE, 18))
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	sens_slider = HSlider.new()
	sens_slider.min_value = 0.02; sens_slider.max_value = 0.5
	sens_slider.step = 0.01; sens_slider.value = GlobalSettings.mouse_sensitivity
	sens_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sens_slider.value_changed.connect(_on_sens)
	row.add_child(sens_slider)
	sens_label = _lbl("%.2f" % GlobalSettings.mouse_sensitivity, COL_ACCENT, 16)
	sens_label.custom_minimum_size.x = 44
	row.add_child(sens_label)
	vb.add_child(row)
	vb.add_child(_spacer(8))
	vb.add_child(_lbl("Controls", COL_WHITE, 18))
	vb.add_child(_lbl("Move ............... W / A / S / D\nJump ............... Space\nGrab Left .......... Left Click\nGrab Right ......... Right Click\nRagdoll ............ R\nFree Mouse ......... Esc", COL_DIM, 14))
	vb.add_child(_spacer(12))
	vb.add_child(_btn("←  B A C K", _show_main))
	return p

# --- Navigation ---
func _show_main():
	main_panel.visible = true; level_panel.visible = false; options_panel.visible = false
func _on_start():
	main_panel.visible = false; level_panel.visible = true
func _on_options():
	main_panel.visible = false; options_panel.visible = true
func _on_exit():
	get_tree().quit()
func _on_level1():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
func _on_level2():
	get_tree().change_scene_to_file("res://Scenes/playground.tscn")
func _on_level3():
	get_tree().change_scene_to_file("res://Scenes/gem_temple.tscn")
func _on_sens(val: float):
	GlobalSettings.mouse_sensitivity = val; sens_label.text = "%.2f" % val
