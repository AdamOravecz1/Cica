extends Area2D

@export var speed = 1 # How fast the player will move (pixels/sec) <- pretty sure this is not per second but ok
@export var player_size: Vector2i = Vector2i(48, 48)
@onready var _MainWindow: Window = get_window() #Creates the window that will move later
var total_maximum_window_size #also mainly for debugging
var start_playable_area = DisplayServer.screen_get_position(DisplayServer.get_keyboard_focus_screen()) #First pixel at the top left
var maximum_window_size = DisplayServer.screen_get_size(DisplayServer.get_keyboard_focus_screen()) #Last pixel at the bottom right
var far_x_limit 
var close_x_limit
var close_y_limit
var far_y_limit
var pet_play_area_y
var pet_play_area_x
var discover_if_taskbar = 0 #This will be used later to discover if the OS has a taskbar or not
var sprite_position_x = 24
var sprite_position_y = 48 
var last_position = _MainWindow
var velocity = Vector2(1, 0) # The player's movement vector.
var facing_right := true

func _ready():
	DisplayServer.window_set_current_screen(DisplayServer.get_keyboard_focus_screen()) #selects screen
	_MainWindow.current_screen = DisplayServer.get_keyboard_focus_screen() #selects screen 
	get_tree().get_root().set_transparent_background(true) 
	Engine.max_fps = 60
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)

	
	total_maximum_window_size = start_playable_area + maximum_window_size #The sum of starting pixel and ending pixel
	
	far_x_limit = total_maximum_window_size - player_size
	close_x_limit = (DisplayServer.screen_get_position(DisplayServer.get_keyboard_focus_screen()))
	
	close_y_limit = start_playable_area #just for easier naming
	far_y_limit = Vector2(maximum_window_size.x, close_y_limit.y) #top right corner

	pet_play_area_y = total_maximum_window_size.y -  get_taskbar_height()
	discover_if_taskbar = pet_play_area_y + sprite_position_y - 7 #If there is a taskbar, this variable's value wil lbe lower on the y axis (AKA higher up on the scree)
	pet_play_area_x = total_maximum_window_size.x /2
	_MainWindow.position.y = pet_play_area_y
	_MainWindow.position.x = pet_play_area_x
	
func _process(delta):
	set_passthrough(position) #Lets you click through the character
	
	#This controls the character movement, then updates the window to fllow the character, makign sure everything stays in its relative place to the middle pixel of the character sprite

	
	last_position = _MainWindow.position
	_MainWindow.position = last_position + Vector2i((velocity*speed)*1.)
	_MainWindow.position = _MainWindow.position.clamp(close_x_limit , far_x_limit)
	if _MainWindow.position == last_position:
		$AnimatedSprite2D.flip_h = facing_right
		facing_right = !facing_right
		velocity.x *= -1
		
	
	#the follwoing determine if the character positions is past the maximum y axis value (pet play area), if it is, it resets that value to the maximum, it also checks if the desktop has a taskbar or not 
	if discover_if_taskbar > pet_play_area_y:
		if _MainWindow.position.y > pet_play_area_y:
			_MainWindow.position.y = pet_play_area_y
	elif _MainWindow.position.y == discover_if_taskbar: 
		if _MainWindow.positiong.y > discover_if_taskbar:
			_MainWindow.position.y = discover_if_taskbar 
			#clear_state()
	
func get_taskbar_height(): #idea from https://www.reddit.com/r/godot/comments/s5rjsv/is_there_a_way_to_get_taskbar_height_on_windows/
	return (total_maximum_window_size.y - DisplayServer.screen_get_usable_rect(DisplayServer.get_keyboard_focus_screen()).size.y - DisplayServer.screen_get_position(DisplayServer.get_keyboard_focus_screen()).y) + player_size.y/1 + player_size.y/3
	
#Sets the coordinates for hitbox, then sets everything outside of that hitbox as non clickable
func set_passthrough(sprite: Vector2):
	#idea from https://medium.com/@chewedgumah/godot-4-partially-clickthrough-window-with-transparent-background-3de637cdf95b
	var texture_corners: PackedVector2Array = [
		position - Vector2(36,24), # Top left corner
		position + Vector2(36, 0) - Vector2(0, 24), # Top right corner
		position + Vector2(24, 0) + Vector2(0, 24), # Bottom right corner
		position - Vector2(28, 0) + Vector2(0, 24) ] # Bottom left corne
	DisplayServer.window_set_mouse_passthrough(texture_corners)

#Resets character status
func clear_state() -> void:
	pass
