extends KinematicBody

export(float) var gravity = -20;
export(int) var maxSpeed = 6;
export(int) var maxSprintSpeed = 10;
export(int) var jumpSpeed = 8;
export(int) var defaultAccel = 3;
export(int) var accelSprint = 6;
export(int) var deAccel = 10;

export(int) var maxLookUp = 70;
export(int) var maxLookDown = 70;
export(float) var maxSlopeAngle = 40;

export(NodePath) var head;

var isSprinting = false;
var isOnFloor;

var dir = Vector3();
var vel = Vector3();

signal aim;

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
	input_walking() # get the input for basic movement
	jump_sprint_crouch() # get the input for jumping, sprinting and crouching

func input_walking():
	var cam_xform = head.get_global_transform()
	
	dir = Vector3() # set dir to an empty Vector3, dir is our direction the player intends to move towards
	var input_movement_vector = Vector2()

	if Input.is_action_pressed("moveForward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("moveBackwards"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("moveLeft"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("moveRight"):
		input_movement_vector.x += 1
	
	if Input.is_action_just_pressed("rightMouse"):
		emit_signal("aim", true);
	if Input.is_action_just_released("rightMouse"):
		emit_signal("aim", false);

	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z * input_movement_vector.y # Forwards/Backwards
	dir += cam_xform.basis.x * input_movement_vector.x # Left/Right

func jump_sprint_crouch():
	# Jump
	if is_on_floor(): # Check if we're on the floor, if we are, we can jump
		if Input.is_action_just_pressed("jump"):
			vel.y = jumpSpeed # Set the y axis of our vel(ocity) to jump_speed
	
	# Sprinting
	if Input.is_action_pressed("sprint"): # if button is pressed
		# dont crouch and sprint
		isSprinting = true # sprint
	else: # if button is not pressed
		isSprinting = false # don't sprint

func processMovement(delta):
	dir.y = 0
	dir = dir.normalized()
	vel.y += delta * gravity # apply gravity
	var hvel = vel # horizontal velocity
	hvel.y = 0
	var target = dir

	if isSprinting: # sprint speed
		target *= maxSprintSpeed
	else: # normal / Walk speed
		target *= maxSpeed

	var accel # final accelaration
	if dir.dot(hvel) > 0: # check if we're moving on the x and z axis (y is 0)
		if isSprinting: # if we're moving and sprinting
			accel = accelSprint # set accel to our sprint accel
		else: # if we're not sprinting
			accel = defaultAccel # normal/walk accel
	else: # if we're not moving, start deaccalerating
		accel = deAccel # slow down

	hvel = hvel.linear_interpolate(target, accel * delta) # interpolate the horizontal velocity
	vel.x = hvel.x # set the velocity to the interpolated horizontal velocity
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(maxSlopeAngle)) # move
	# deg2rad = degrees converted to radians
