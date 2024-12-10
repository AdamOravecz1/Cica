extends Node2D
@onready var cat = $Cat






func _process(delta):

	if Input.is_action_just_pressed("close"):
		get_tree().quit()
		
	
		
