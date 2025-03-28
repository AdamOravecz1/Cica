extends Node2D

var passthrough_update_timer = 0
var passthrough_update_interval = 0.0

var down := true
var on_floor := true

var texture_corners: Array
var last_cat_pos = Vector2()
var middle_cat_pos = Vector2()

var screen_size_y = DisplayServer.screen_get_size().y

func _process(delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	

	if texture_corners.size() >= 10:
		DisplayServer.window_set_mouse_passthrough(texture_corners)
		texture_corners = PackedVector2Array()
		
		
func set_passthrough(cat_pos: Vector2, enable, falling, playing):
	var down_cut := 30
	if playing:
		down_cut = 10
	if enable and !falling and down:
		if (cat_pos.x > last_cat_pos.x - 110 and cat_pos.x < last_cat_pos.x + 110) and (cat_pos.y > last_cat_pos.y - 100 and cat_pos.y < last_cat_pos.y + 100) and on_floor:
			middle_cat_pos = (last_cat_pos + cat_pos) / 2
		
			texture_corners.append(middle_cat_pos - Vector2(120, 128)) # Top left corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0) - Vector2(0, 128)) # Top right corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0) - Vector2(0, down_cut)) # Bottom right corner
			texture_corners.append(middle_cat_pos - Vector2(120, 0) - Vector2(0, down_cut)) # Bottom left corne
			DisplayServer.window_set_mouse_passthrough(texture_corners)
			texture_corners = PackedVector2Array()
		else:
			
			texture_corners.append(cat_pos - Vector2(62, 128)) # Top left corner
			texture_corners.append(cat_pos + Vector2(46, 0) - Vector2(0, 128)) # Top right corner
			texture_corners.append(cat_pos + Vector2(46, 0) - Vector2(0, down_cut)) # Bottom right corner
			texture_corners.append(cat_pos - Vector2(62, 0) - Vector2(0, down_cut)) # Bottom left corne
			texture_corners.append(cat_pos - Vector2(62, 128)) # for the complete square
		last_cat_pos = cat_pos
	elif enable and down:
		if (cat_pos.x > last_cat_pos.x - 100 and cat_pos.x < last_cat_pos.x + 100) and (cat_pos.y > last_cat_pos.y - 100 and cat_pos.y < last_cat_pos.y + 100):
			middle_cat_pos = (last_cat_pos + cat_pos) / 2
			texture_corners = PackedVector2Array()
			DisplayServer.window_set_mouse_passthrough(texture_corners) # Disable passthrough by setting an empty array
			texture_corners.append(middle_cat_pos - Vector2(120, 200)) # Top left corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0) - Vector2(0, 200)) # Top right corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0)) # Bottom right corner
			texture_corners.append(middle_cat_pos - Vector2(120, 0)) # Bottom left corne
			DisplayServer.window_set_mouse_passthrough(texture_corners)
			texture_corners = PackedVector2Array()
		else:
			texture_corners.append(cat_pos - Vector2(62, 128)) # Top left corner
			texture_corners.append(cat_pos + Vector2(46, 0) - Vector2(0, 128)) # Top right corner
			texture_corners.append(cat_pos + Vector2(46, 0)) # Bottom right corner
			texture_corners.append(cat_pos - Vector2(62, 0)) # Bottom left corne
			texture_corners.append(cat_pos - Vector2(62, 128)) # for the complete square
		last_cat_pos = cat_pos


func up():
	on_floor = false
	down = false
	texture_corners = PackedVector2Array()
	DisplayServer.window_set_mouse_passthrough(texture_corners) # Disable passthrough by setting an empty array
	
func not_up():
	down = true
	
