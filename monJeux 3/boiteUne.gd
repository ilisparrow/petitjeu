extends RigidBody2D
var impGravity=10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"gfh


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
	
func _physics_process(delta):
	var _personnage = get_node("../KinematicBody2D")
	set_gravity_scale(_personnage.globalVar*impGravity)
	print(gravity_scale)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.

#	pass
