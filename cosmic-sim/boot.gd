extends Control
## Заставка «create by puzatiyw» -> главное меню -> игра (main.tscn)

var accent := Color(0.36, 0.78, 1.0)
var bold_font: SystemFont
var bg: TextureRect
var menu_root: Control
var credits_panel: PanelContainer
var intro_label: Label
var intro_tween: Tween
var fade: ColorRect
var intro_done := false
var busy := false

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	theme = make_theme()
	var black := ColorRect.new()
	black.color = Color.BLACK
	black.set_anchors_preset(Control.PRESET_FULL_RECT)
	black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(black)
	build_menu()
	intro_label = Label.new()
	intro_label.text = "create by puzatiyw"
	intro_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	intro_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	intro_label.add_theme_font_size_override("font_size", 38)
	intro_label.add_theme_color_override("font_color", Color(0.92, 0.94, 0.98))
	intro_label.modulate.a = 0.0
	add_child(intro_label)
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fade)
	if Engine.has_meta("skip_intro"):
		Engine.remove_meta("skip_intro")
		intro_label.visible = false
		show_menu(false)
	else:
		intro_tween = create_tween()
		intro_tween.tween_interval(0.6)
		intro_tween.tween_property(intro_label, "modulate:a", 1.0, 1.4)
		intro_tween.tween_interval(1.8)
		intro_tween.tween_property(intro_label, "modulate:a", 0.0, 1.2)
		intro_tween.tween_interval(0.4)
		intro_tween.tween_callback(func(): show_menu(true))

func _unhandled_input(event: InputEvent) -> void:
	if intro_done:
		return
	if (event is InputEventKey and event.pressed) or (event is InputEventMouseButton and event.pressed):
		if intro_tween != null:
			intro_tween.kill()
		intro_label.visible = false
		show_menu(true)

func make_theme() -> Theme:
	var th := Theme.new()
	var names := PackedStringArray(["Segoe UI Variable Text", "Segoe UI", "Inter", "Roboto", "Noto Sans", "Arial"])
	var f := SystemFont.new()
	f.font_names = names
	th.default_font = f
	th.default_font_size = 16
	bold_font = SystemFont.new()
	bold_font.font_names = names
	bold_font.font_weight = 700
	return th

func mk_button(text: String, cb: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(340, 56)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var n := StyleBoxFlat.new()
	n.bg_color = Color(0.04, 0.06, 0.1, 0.62)
	n.border_color = Color(accent, 0.35)
	n.set_border_width_all(1)
	n.set_corner_radius_all(12)
	n.content_margin_left = 24.0
	n.content_margin_right = 24.0
	n.content_margin_top = 14.0
	n.content_margin_bottom = 14.0
	n.shadow_color = Color(0, 0, 0, 0.4)
	n.shadow_size = 10
	var h := n.duplicate() as StyleBoxFlat
	h.bg_color = Color(accent.r, accent.g, accent.b, 0.22)
	h.border_color = Color(accent, 0.95)
	var p := n.duplicate() as StyleBoxFlat
	p.bg_color = Color(accent.r, accent.g, accent.b, 0.4)
	p.border_color = Color(accent, 1.0)
	b.add_theme_stylebox_override("normal", n)
	b.add_theme_stylebox_override("hover", h)
	b.add_theme_stylebox_override("pressed", p)
	b.add_theme_font_override("font", bold_font)
	b.add_theme_font_size_override("font_size", 20)
	b.add_theme_color_override("font_color", Color(0.9, 0.93, 0.98))
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.pressed.connect(cb)
	return b

func build_menu() -> void:
	menu_root = Control.new()
	menu_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_root.visible = false
	menu_root.modulate.a = 0.0
	add_child(menu_root)
	bg = TextureRect.new()
	bg.texture = load("res://assets/menu.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_root.add_child(bg)
	# лёгкое затемнение справа, чтобы кнопки читались
	var gr := Gradient.new()
	gr.offsets = PackedFloat32Array([0.0, 0.55, 1.0])
	gr.colors = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0.15), Color(0, 0, 0, 0.55)])
	var gt := GradientTexture2D.new()
	gt.gradient = gr
	gt.fill_from = Vector2(0, 0)
	gt.fill_to = Vector2(1, 0)
	gt.width = 256
	gt.height = 4
	var shade := TextureRect.new()
	shade.texture = gt
	shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	shade.stretch_mode = TextureRect.STRETCH_SCALE
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_root.add_child(shade)
	var holder := Control.new()
	holder.anchor_left = 0.60
	holder.anchor_right = 0.94
	holder.anchor_top = 0.15
	holder.anchor_bottom = 0.85
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_root.add_child(holder)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	holder.add_child(box)
	var title := Label.new()
	title.text = "COSMIC SIMULATION"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", bold_font)
	title.add_theme_font_size_override("font_size", 46)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.add_theme_color_override("font_shadow_color", Color(accent, 0.55))
	title.add_theme_constant_override("shadow_offset_x", 0)
	title.add_theme_constant_override("shadow_offset_y", 0)
	title.add_theme_constant_override("shadow_outline_size", 10)
	box.add_child(title)
	var sub := Label.new()
	sub.text = "БОГ ВСЕЛЕННОЙ"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 20)
	sub.add_theme_color_override("font_color", Color(accent, 0.9))
	box.add_child(sub)
	var sp := Control.new()
	sp.custom_minimum_size = Vector2(0, 28)
	box.add_child(sp)
	for entry in [["ИГРАТЬ", start_game], ["КРЕДИТЫ", show_credits], ["ВЫХОД", quit_game]]:
		var row := CenterContainer.new()
		row.add_child(mk_button(entry[0], entry[1]))
		box.add_child(row)
	# КРЕДИТЫ
	credits_panel = PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.03, 0.04, 0.07, 0.9)
	sb.border_color = Color(accent, 0.4)
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(16)
	sb.set_content_margin_all(36)
	sb.shadow_color = Color(0, 0, 0, 0.5)
	sb.shadow_size = 24
	credits_panel.add_theme_stylebox_override("panel", sb)
	credits_panel.anchor_left = 0.5
	credits_panel.anchor_right = 0.5
	credits_panel.anchor_top = 0.5
	credits_panel.anchor_bottom = 0.5
	credits_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	credits_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	credits_panel.visible = false
	menu_root.add_child(credits_panel)
	var cv := VBoxContainer.new()
	cv.add_theme_constant_override("separation", 22)
	credits_panel.add_child(cv)
	var ct := Label.new()
	ct.text = "КРЕДИТЫ"
	ct.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ct.add_theme_font_override("font", bold_font)
	ct.add_theme_font_size_override("font_size", 30)
	ct.add_theme_color_override("font_color", Color(accent, 1.0))
	cv.add_child(ct)
	var cx := Label.new()
	cx.text = "Игра сделана за 3 дня,\nпросьба не обижаться"
	cx.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cx.add_theme_font_size_override("font_size", 24)
	cv.add_child(cx)
	var back := CenterContainer.new()
	back.add_child(mk_button("НАЗАД", hide_credits))
	cv.add_child(back)

func show_menu(animated: bool) -> void:
	intro_done = true
	menu_root.visible = true
	if animated:
		var tw := create_tween()
		tw.tween_property(menu_root, "modulate:a", 1.0, 1.5)
	else:
		menu_root.modulate.a = 1.0
	bg.pivot_offset = get_viewport_rect().size * 0.5
	var zoom := create_tween().set_loops()
	zoom.tween_property(bg, "scale", Vector2(1.05, 1.05), 22.0).set_trans(Tween.TRANS_SINE)
	zoom.tween_property(bg, "scale", Vector2(1.0, 1.0), 22.0).set_trans(Tween.TRANS_SINE)

func show_credits() -> void:
	credits_panel.modulate.a = 0.0
	credits_panel.visible = true
	create_tween().tween_property(credits_panel, "modulate:a", 1.0, 0.25)

func hide_credits() -> void:
	credits_panel.visible = false

func start_game() -> void:
	if busy:
		return
	busy = true
	var tw := create_tween()
	tw.tween_property(fade, "color:a", 1.0, 0.6)
	tw.tween_callback(func(): get_tree().change_scene_to_file("res://main.tscn"))

func quit_game() -> void:
	get_tree().quit()
