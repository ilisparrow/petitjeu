extends KinematicBody2D

const UP=Vector2(0,-1)
const MAX_SPEED=200
const ACCELERATION=50
var GRAVITY=20
const JUMP=400
var friction=false
var lebool=false
var mouvement=Vector2()# vecteur vitesse et non position V(x,y), équivalent à crée deux variale x=0 et y=0


func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_SPACE) and just_pressed and (is_on_floor() or is_on_ceiling()):
		GRAVITY=-GRAVITY
		#$Camera2D.rotating=!lebool
		$Sprite.flip_v=!lebool
		$Camera2D.rotation_degrees=180
		lebool=!lebool
	if Input.is_key_pressed(KEY_Q):
		GRAVITY=0
	if Input.is_key_pressed(KEY_A):
		GRAVITY=20
		
func _physics_process(delta):
	var glisse=get_parent().get_node("glisse")
	var bodies=glisse.get_overlapping_bodies()
	print(bodies)
	if mouvement.y>0:#-------------------------------------------------
		mouvement.y=min(mouvement.y+GRAVITY,1000)
	elif mouvement.y<0:                   #limité l'acceleration gravitationelle entre (-1000 et 1000)
		mouvement.y=max(-1000,mouvement.y+GRAVITY)
	else:
		mouvement.y+=GRAVITY#----------------------------------------
	

	if Input.is_action_pressed("ui_right"):
		mouvement.x=min(mouvement.x+ACCELERATION,MAX_SPEED)
		$Sprite.flip_h=false# retourne le sprites horizontalement(initialement on ne veut pas le retourner)
		$Sprite.play("run")
	
	elif Input.is_action_pressed("ui_left"):

		mouvement.x=max(mouvement.x-ACCELERATION,-MAX_SPEED)
		$Sprite.flip_h=true
		$Sprite.play("run")
	else: 
		$Sprite.play("idle")
		friction=true
		
	
		
	if is_on_floor(): #the floor is on V(0,0)  
		if Input.is_action_just_pressed("ui_up"):#on utilise just_pressed pour le saut
			mouvement.y=-JUMP
		if friction==true:
			for body in bodies:
				if body.name=="KinematicBody2D":
					mouvement.x=lerp(mouvement.x,0,-0.25)
				elif body.name!="KinematicBody2D":
					mouvement.x=lerp(mouvement.x,0,0.2)
	elif is_on_ceiling()  :
		if Input.is_action_just_pressed("ui_up"):#on utilise just_pressed pour le saut
			mouvement.y=JUMP
		if friction==true:					
			mouvement.x=lerp(mouvement.x,0,0.2)
	else:
		if mouvement.y<0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")
		if friction==true:
			mouvement.x=lerp(mouvement.x,0,0.2)
		if mouvement.y==0:
			$Sprite.play("fall")
	

	mouvement=move_and_slide(mouvement,UP)#déplace notre KB

	
	pass
