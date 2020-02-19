extends Area2D

var a_recu_degat=false

func _physics_process(delta):
	
	
	#t.set_one_shot(false)
	var bar_de_vie=get_parent().get_node("KinematicBody2D/TextureProgress")
	var bodies=get_overlapping_bodies()
	for body in bodies:
		if body.name=="KinematicBody2D" and a_recu_degat==false:
			bar_de_vie.value-=10
			a_recu_degat=true
			
			var t= Timer.new()
			t.set_wait_time(1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			#t.queue_free()
			a_recu_degat=false
			
	pass 
