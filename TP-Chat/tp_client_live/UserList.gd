extends Node2D

onready var vbox_list = $Panel/VBoxPlayer/scroller/VBoxList
onready var lb_title = $Panel/VBoxPlayer/lb_title
# Called when the node enters the scene tree for the first time.


func _ready():
	pass

func updat(users):
	clean()
	for i in users:
		var new_node = Label.new()
		new_node.name=str(users[i].pid)
		vbox_list.add_child(new_node)
		new_node.set_text("%s (%d) "%[users[i].nickname,users[i].pid])
	set_nb_users (len(users))

func clean():
	for i in vbox_list.get_children():
		i.queue_free()

	
func set_nb_users(n: int):
	lb_title.text = "%d users connected"%[n]
