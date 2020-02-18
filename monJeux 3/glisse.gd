extends Area2D


func _physics_process(delta):
	var bodies=get_overlapping_bodies()
	for body in bodies:
		if body.name=="KinematicBody2D":
			mouvement.x=lerp(mouvement.x,0,0.2)
	pass 
