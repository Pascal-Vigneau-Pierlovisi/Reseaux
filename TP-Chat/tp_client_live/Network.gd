extends Control

signal connected
signal ask_pseudo
signal message_received
signal new_client2
signal new_client
signal deco_client

var server_info = {}
var user = {}
var CLOCK_CLIENT = 0
var DECIMAL_COLLECTOR = 0

var my_data = {
	"pseudo" : "NA",
	"pid": -1,
}

func _ready():
	get_tree().connect("connected_to_server",self,"_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")
	set_physics_process(false)

onready var CS = preload("res://ChatScene.tscn").instance()

func join_server(ip, port, pseudo):
	print(port)
	var net = NetworkedMultiplayerENet.new()
	my_data["pseudo"] = pseudo
	if (net.create_client(ip,int(port)) != OK):
		print("Failed to create client")
		#emit_signal("join_fail")
		return
	get_tree().set_network_peer(net)
	print("Server joined!")

func send_pseudo(pseudo):
	print(pseudo)
	rpc_id(1, "pseudo_from_client", pseudo)


remote func message_from_server(mess):
	print("susi baka")
	print("Message received from server : %s"%[mess])
	emit_signal("message_received", mess)

func send_message_to_server(mess: Message):
	rpc_id(1, "chat_message", mess.to_dict())

func _on_connected_to_server():
	print("Connection success !")
	rpc_id(1, "fetch_server_time", OS.get_system_time_msecs())
	emit_signal("connected")
	var pid = get_tree().get_network_unique_id()
	my_data["pid"] = pid
	emit_signal("ask_pseudo")
	print("My pid is %d. Sending a test message."%[pid])
	
remote func timestamp_from_server(timeSer, timeCli):
	CLOCK_CLIENT = timeSer + (timeSer - OS.get_system_time_msecs())
	set_physics_process(true)
	print(str(CLOCK_CLIENT) + "\n", str(timeSer) + "\n", str(timeCli))
	
func _physics_process(delta):
	CLOCK_CLIENT += int(delta*1000)
	DECIMAL_COLLECTOR += (delta * 1000) - int(delta * 1000)
	if DECIMAL_COLLECTOR >= 1.0:
		CLOCK_CLIENT += 1
		DECIMAL_COLLECTOR -= 1

func _on_connection_failed():
	print("the connection has failed!")

func _on_disconnected_from_server():
	my_data["pid"] = -1
	rpc_id(1, "client_disconnected")
	print("Disconnected !")

remote func new_user(numUser, dict):
	print(dict)
	var usr = "user" + str(numUser)
	user = dict
	emit_signal("new_client", user[usr].nickname)
	emit_signal("new_client2", user)
	print(user)
	

remote func user_deco(dict):
	user = dict
	emit_signal("deco_client", user)
