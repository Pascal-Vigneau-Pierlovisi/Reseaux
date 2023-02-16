extends Node

var SERVER_PORT = 3892
var MAX_PLAYERS = 16
var dict = {}
var nbUser = 0


func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")


remote func pseudo_from_client(pseudo):
	print(pseudo)
	var pid = get_tree().get_rpc_sender_id()
	for e in dict:
		if dict[e].pid == pid:
			dict[e].nickname = pseudo
	send_new_connection()

remote func chat_message(mess):
	var pid = get_tree().get_rpc_sender_id()
	print("Message received from %d: %s"%[pid, mess])
	for e in dict: 
		if dict[e].pid == pid:
			mess["nickname"] = dict[e].nickname
	for e in dict:
		print(dict, e, "jjjjjj")
		rpc_id(dict[e].pid, "message_from_server", mess)
	
remote func fetch_server_time(timeCli):
	var pid = get_tree().get_rpc_sender_id()
	var timeSer = OS.get_system_time_msecs()
	print(timeSer)
	rpc_id(pid, "timestamp_from_server", timeSer, timeCli)
	

func _on_network_peer_connected (id: int):
	print("New client connected: %d"%[id])
	var usr = "user" + str(nbUser) 
	dict[usr] = {"pid": id, "nickname": "pseudo"}
	print(dict)

func _on_network_peer_disconnected (id: int):
	print("Client disconnected: %d"%[id])	
	for e in dict:
		if dict[e].pid == id:
			dict.erase(e)
	print(dict)
	for e in dict: 
		rpc_id(dict[e].pid, "user_deco", dict)
	nbUser -= 1
	


func send_new_connection():
	print(dict)
	for e in dict: 
		rpc_id(dict[e].pid, "new_user", nbUser, dict)
	nbUser += 1
