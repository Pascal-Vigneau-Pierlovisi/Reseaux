extends Control

# Called when the node enters the scene tree for the first time.
onready var chatBox = $ChatBox
onready var connectionBox = $ConnectionBox
onready var userList = $UserList
onready var msgBubble = $MsgBubble

func _ready():
	chatBox.connect("message_sent",self,"_on_ChatBox_message_sent")
	connectionBox.connect("send_pseudo", self, "get_pseudo")
	Network.connect("new_client", self, "pop_up_new_client")
	Network.connect("new_client2", self, "display_new_list")
	Network.connect("ask_pseudo", self, "get_pseudo")
	Network.connect("deco_client", self, "display_new_list")
	
func pop_up_new_client(pseudo: String):
	msgBubble.display_message(pseudo)

func display_new_list(users):
	userList.updat(users)
	
func get_pseudo():
	var login = get_node("ConnectionBox")
	var pseudo = login.send_pseudo()
	Network.send_pseudo(pseudo)
	
func _on_ChatBox_message_sent(mess):
	Network.send_message_to_server(mess)
	

