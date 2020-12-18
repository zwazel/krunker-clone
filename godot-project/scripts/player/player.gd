extends KinematicBody

export(float) var gravity = -20;
export(int) var maxSpeed = 6;
export(int) var maxSprintSpeed = 10;
export(int) var jumpSpeed = 8;
export(int) var accel = 3;
export(int) var accelSprint = 6;

export(int) var deAccel = 10;

export(int) var maxLookUp = 70;
export(int) var maxLookDown = 70;

export(NodePath) var head;

var isSprinting = false;
var isOnFloor;

var dir = Vector3();
var vel = Vector3();

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	head = get_node(head);
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_x(deg2rad(event.relative.y * Global.mouseSens));
		self.rotate_y(deg2rad(event.relative.x * Global.mouseSens * -1));
		
		# Clamp Camera rotation (up/down)
		var cameraRotation = head.rotation_degrees;
		cameraRotation.x = clamp(cameraRotation.x, -maxLookDown, maxLookUp);
		head.rotation_degrees = cameraRotation;

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _physics_process(delta):
	processInput();
	processMovement(delta);
	
func processInput():
	pass
	
func processMovement(delta):
	pass
