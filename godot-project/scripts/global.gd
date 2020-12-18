extends Node

var mouseSens = 0.05;
var playerFov = 100;
var playerViewDistance = 500;

#func _ready():
#	if OS.has_feature("standalone"):
#		print("Running an exported build.")
#	else:
#		print("Running from the editor.")
