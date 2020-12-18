extends Camera

func _ready():
	fov = Global.playerFov
	far = Global.playerViewDistance

func _process(delta):
	if fov != Global.playerFov:
			fov = Global.playerFov
			
	if far != Global.playerViewDistance:
		far = Global.playerViewDistance
