extends Camera

var aimFov = 50;
var aimSpeed = 5;
var aim = false;

func _ready():
	fov = Global.playerFov
	far = Global.playerViewDistance

func _process(delta):
	if aim:
		if fov > aimFov:
			fov -= aimSpeed;
	else:
		if fov < Global.playerFov:
			fov += aimSpeed;
	
#	if fov != Global.playerFov:
#		fov = Global.playerFov
			
	if far != Global.playerViewDistance:
		far = Global.playerViewDistance

func _on_KinematicBody_aim(state):
	aim = state;
