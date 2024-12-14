extends Node2D
@onready var cat = $Cat

var down := true

var texture_corners: Array
var last_cat_pos = Vector2()
var middle_cat_pos = Vector2()

func _process(delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	
	if texture_corners.size() >= 10:
		DisplayServer.window_set_mouse_passthrough(texture_corners)
		texture_corners = PackedVector2Array()
		
		
func set_passthrough(cat_pos: Vector2, enable, falling):
	if enable and !falling and down:
		if (cat_pos.x > last_cat_pos.x - 100 and cat_pos.x < last_cat_pos.x + 100) and (cat_pos.y > last_cat_pos.y - 100 and cat_pos.y < last_cat_pos.y + 100):
			middle_cat_pos = (last_cat_pos + cat_pos) / 2
			$ColorRect.color = 125
			texture_corners.append(middle_cat_pos - Vector2(120, 108)) # Top left corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0) - Vector2(0, 108)) # Top right corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0) - Vector2(0, 40)) # Bottom right corner
			texture_corners.append(middle_cat_pos - Vector2(120, 0) - Vector2(0, 40)) # Bottom left corne
			DisplayServer.window_set_mouse_passthrough(texture_corners)
			texture_corners = PackedVector2Array()
		else:
			$ColorRect.color = 125
			texture_corners.append(cat_pos - Vector2(62, 108)) # Top left corner
			texture_corners.append(cat_pos + Vector2(46, 0) - Vector2(0, 108)) # Top right corner
			texture_corners.append(cat_pos + Vector2(46, 0) - Vector2(0, 40)) # Bottom right corner
			texture_corners.append(cat_pos - Vector2(62, 0) - Vector2(0, 40)) # Bottom left corne
			texture_corners.append(cat_pos - Vector2(62, 108)) # for the complete square
		last_cat_pos = cat_pos
	elif enable and down:
		if (cat_pos.x > last_cat_pos.x - 100 and cat_pos.x < last_cat_pos.x + 100) and (cat_pos.y > last_cat_pos.y - 100 and cat_pos.y < last_cat_pos.y + 100):
			middle_cat_pos = (last_cat_pos + cat_pos) / 2
			$ColorRect.color = 125
			texture_corners.append(middle_cat_pos - Vector2(120, 200)) # Top left corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0) - Vector2(0, 200)) # Top right corner
			texture_corners.append(middle_cat_pos + Vector2(90, 0)) # Bottom right corner
			texture_corners.append(middle_cat_pos - Vector2(120, 0)) # Bottom left corne
			DisplayServer.window_set_mouse_passthrough(texture_corners)
			texture_corners = PackedVector2Array()
		else:
			$ColorRect.color = 125
			texture_corners.append(cat_pos - Vector2(62, 200)) # Top left corner
			texture_corners.append(cat_pos + Vector2(46, 0) - Vector2(0, 200)) # Top right corner
			texture_corners.append(cat_pos + Vector2(46, 0)) # Bottom right corner
			texture_corners.append(cat_pos - Vector2(62, 0)) # Bottom left corne
			texture_corners.append(cat_pos - Vector2(62, 200)) # for the complete square
		last_cat_pos = cat_pos


func up():
	down = false
	texture_corners = PackedVector2Array()
	DisplayServer.window_set_mouse_passthrough(texture_corners) # Disable passthrough by setting an empty array
	
func not_up():
	down = true
	
