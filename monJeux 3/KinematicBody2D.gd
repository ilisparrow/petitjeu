extends KinematicBody2D

const UP=Vector2(0,-1)
const MAX_SPEED=200
const ACCELERATION=50
var GRAVITY=20
const JUMP=400
var friction=false
var lebool=false
var mouvement=Vector2()# vecteur vitesse et non position V(x,y), équivalent à crée deux variale x=0 et y=0
var WIND=0
var STEPWIND = 7
var inertiaMainCaractere = 10
var globalVar = 1


func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_SPACE) and just_pressed and (is_on_floor() or is_on_ceiling()):
		GRAVITY=-GRAVITY
		globalVar = GRAVITY/abs(GRAVITY)
		#$RigidBody2D.gravity_scale=GRAVITY/(abs(GRAVITY))
		#$Camera2D.rotating=!lebool
		$Sprite.flip_v=!lebool
		$Camera2D.rotation_degrees=180
		lebool=!lebool
	if Input.is_key_pressed(KEY_W) and just_pressed:
		WIND-=STEPWIND

		#print(WIND)
	if Input.is_key_pressed(KEY_X) and just_pressed:
		WIND+=STEPWIND
		#print(WIND)
	#if Input.is_key_pressed(KEY_Q):
	#	GRAVITY=0
	#if Input.is_key_pressed(KEY_A):
	#	GRAVITY=20
		
func _physics_process(delta):
	mouvement.x+=WIND
	var glisse=get_parent().get_node("glisse")
	var bodies=glisse.get_overlapping_bodies()

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
			$Sprite.play("fall")
			mouvement.y=-JUMP
		if friction==true:
			for body in bodies:
				if body.name=="KinematicBody2D":
					mouvement.x=lerp(mouvement.x,0,-0.24)
					
			#var kinematic_touche=false
			#for i in range(len(bodies)):
				#var colli=bodies[i]
				#if colli.is_class("KinematicBody2D"):
				#	kinematic_touche=true
				#if kinematic_touche:
					#mouvement.x=lerp(mouvement.x,0,-0.25)
					#kinematic_touche=false
	
				else:
					mouvement.x=lerp(mouvement.x,0,0.1)
	elif is_on_ceiling()  :
		if Input.is_action_just_pressed("ui_up"):#on utilise just_pressed pour le saut
			mouvement.y=JUMP
		if friction==true:					
			mouvement.x=lerp(mouvement.x,0,0.2)
	else:
		var boolsaut=true
		if mouvement.y<0:
			$Sprite.play("jump")
		else:
			$Sprite.frame=0
			while boolsaut:
				$Sprite.play("fall")
				$Sprite.frame+=1
				if $Sprite.frame==19:
					boolsaut=false
					$Sprite.frame==0

		if friction==true:
			mouvement.x=lerp(mouvement.x,0,0.2)
		$Sprite.frame=0
		if mouvement.y==0:
			while boolsaut:
				$Sprite.play("fall")
				$Sprite.frame+=1
				if $Sprite.frame==19:
					boolsaut=false
					$Sprite.frame==0

	
	mouvement=move_and_slide(mouvement,UP,false,4,PI/4,false)#déplace notre KB
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		#print(collision.collider.is_class("RigidBody2D"))
		if collision.collider.is_class("RigidBody2D"):
			#print("Colliding")
			collision.collider.apply_central_impulse(-collision.normal*inertiaMainCaractere)
	
	pass
