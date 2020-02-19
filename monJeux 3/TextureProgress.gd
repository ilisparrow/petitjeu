extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _input(event):
	if Input.is_key_pressed(KEY_M):
		value-=10
	if Input.is_key_pressed(KEY_P):
		value+=10
	#if value<25:
	#	tint_progress=Color(255,0,0,255)
	#else:
	#	tint_progress=Color(1,1,1,1)
		 
		
		
		



	
