extends Control

signal send_pseudo
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var input_ip = $Panel/VBoxContainer/adresse_ip
onready var input_port = $Panel/VBoxContainer/port
onready var input_pseudo = $Panel/VBoxContainer/pseudo
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ConnectionBox ready!")

func send_pseudo():
	return input_pseudo.text

func _on_Button_button_down():
	var ip_addr = input_ip.text
	var port = input_port.text
	var nick = input_pseudo.text
	Network.join_server(ip_addr, port, nick)
