extends Area2D

var speed = 50
var fall_speed = 500
var direction = 1
var facing_left := false
var dragging := false
var falling := false

var total_maximum_window_size #also mainly for debugging
var start_playable_area = DisplayServer.screen_get_position(DisplayServer.get_keyboard_focus_screen()) #First pixel at the top left
var maximum_window_size = DisplayServer.screen_get_size(DisplayServer.get_keyboard_focus_screen()) #Last pixel at the bottom right
var passthrough_update_timer = 0
var passthrough_update_interval = 0.05
var screen_size = DisplayServer.screen_get_size().x
var floor = DisplayServer.screen_get_usable_rect(DisplayServer.get_keyboard_focus_screen()).size.y - DisplayServer.screen_get_position(DisplayServer.get_keyboard_focus_screen()).y

func _ready():
	total_maximum_window_size = start_playable_area + maximum_window_size #The sum of starting pixel and ending pixel
	position.y = floor
	print(position)
	
	$RestTimer.wait_time = randi_range(5, 60)
	$RestTimer.start()

func turn():
	facing_left = !facing_left
	direction *= -1
	$AnimatedSprite2D.flip_h = facing_left

func _process(delta):
	if Input.is_action_just_pressed("click"):
		speed = 0
		dragging = !dragging
		$RestTimer.stop()
		$AnimatedSprite2D.play("up")
		
	passthrough_update_timer += delta
	if passthrough_update_timer >= passthrough_update_interval:
		set_passthrough(position, !dragging, falling)
		passthrough_update_timer = 0
		
	if (position.x > screen_size-50 or position.x < 50) and !falling and !dragging:
		turn()
		
	if dragging:
		position = get_global_mouse_position() + Vector2(0, 50)
	elif falling:
		$AnimatedSprite2D.play("fall")
		
	global_position.x += speed*direction*delta
	if position.y < floor and !dragging:
		falling = true
		global_position.y += fall_speed*delta
	elif position.y > floor and (falling or !dragging):
		falling = false
		global_position.y = floor
		$RestTimer.start()
		$AnimatedSprite2D.play("walk")
		speed = 50
		if position.x > screen_size-50:
			position.x = screen_size-50
		if position.x < 50:
			position.x = 50
		
		
func _on_rest_timer_timeout():
	if speed == 50:
		speed = 0
		$AnimatedSprite2D.play("rest")
	else:
		$AnimatedSprite2D.play("wake_up")
		
	$RestTimer.wait_time = randi_range(5, 60)
	$RestTimer.start()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "wake_up":
		$AnimatedSprite2D.play("walk")
		speed = 50
		
func set_passthrough(cat_pos: Vector2, enable, falling):
	if enable and !falling:
		var texture_corners: PackedVector2Array = [
			cat_pos - Vector2(62, 108), # Top left corner
			cat_pos + Vector2(46, 0) - Vector2(0, 108), # Top right corner
			cat_pos + Vector2(46, 0) - Vector2(0, 32), # Bottom right corner
			cat_pos - Vector2(62, 0) - Vector2(0, 32)] # Bottom left corne
		DisplayServer.window_set_mouse_passthrough(texture_corners)
	elif enable:
		var texture_corners: PackedVector2Array = [
			cat_pos - Vector2(62, 200), # Top left corner
			cat_pos + Vector2(46, 0) - Vector2(0, 200), # Top right corner
			cat_pos + Vector2(46, 0), # Bottom right corner
			cat_pos - Vector2(62, 0)] # Bottom left corne
		DisplayServer.window_set_mouse_passthrough(texture_corners)
	else:
		# Disable passthrough by setting an empty array
		DisplayServer.window_set_mouse_passthrough(PackedVector2Array())
		


