extends Panel

const TEXT_DISPLAY_MIN_TIME = 4.0 #secs

var text_duration = TEXT_DISPLAY_MIN_TIME

onready var rtl_mess = $rtl_mess
onready var timer = $Timer

func _ready():
	Network.connect("new_client", self, "display_message")
	hide()
	
func display_message(pseudo: String):
	rtl_mess.text = "User " + pseudo + " is connected"
	timer.start(text_duration)
	show()

func set_text_duration(s: float):
	text_duration = s

func _on_Timer_timeout():
	hide()
