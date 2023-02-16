extends Control

onready var chatLog = $VBoxContainer/RichTextLabel
onready var inputNickname = $VBoxContainer/HBoxContainer/Label
onready var inputField = $VBoxContainer/HBoxContainer/LineEdit

signal message_sent

func _ready():
	inputField.set_editable(false)
	Network.connect("message_received",self, "show_message")
	Network.connect("connected",self, "_on_connected")
	
func _on_connected():
	inputField.set_editable(true)
	

		
func send_message(text):
	var timeDict = OS.get_time()
	var hour = timeDict.hour
	var minute = timeDict.minute
	var second = timeDict.second
	var temps = str(hour) + ":" + str(minute) + ":" + str(second)
	var mess = Message.new(1,temps,str(text))
	emit_signal("message_sent", mess)
	inputField.text= ''

func show_message(mess):
	print(mess)
	chatLog.bbcode_text+= "\n" + to_dict_display(mess)
	
func to_dict_display(mess):
	return mess.timestamp + "[" + mess.nickname + "]" + mess.content
