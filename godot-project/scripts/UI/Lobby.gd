extends Control

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected") # https://youtu.be/K0luHLZxjBA?t=245

func _on_ButtonHost_pressed(): # when clicking on the button
	var net = NetworkedMultiplayerENet.new() # create a new multiplayer network
	net.create_server(6969, 10) # create a server (port, maximum amount of clients (max 4096))
	get_tree().set_network_peer(net)
	print("hosting")

func _on_ButtonJoin_pressed(): # when clicking on the button
	var net = NetworkedMultiplayerENet.new() # create a new multiplayer network
	net.create_client("127.0.0.1", 6969) # create a client (server (which we want to connect to), port of the server)
	get_tree().set_network_peer(net)
	print("joining")
	
func _player_connected(id):
	Global.player2id = id
	var world = preload("res://scenes/world.tscn").instance()
	get_tree().get_root().add_child(world)
	hide()
