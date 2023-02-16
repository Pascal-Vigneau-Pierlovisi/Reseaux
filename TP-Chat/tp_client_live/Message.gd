class_name Message extends Object

var mess_id: int
var net_id: int
var timestamp: String
var nickname: String
var content: String

#constructeur
func _init(id: int, ts : String, m: String) :
	mess_id = 0
	net_id = id
	timestamp = ts
	content = m

func to_string_display():
	return timestamp+"["+str(net_id)+"]"+str(content)

func to_string():
	print(str(mess_id) + str(net_id) + timestamp + str(var2bytes(mess_id)) + content)

func to_dict():
	return {
		"mess_id": mess_id,
		"net_id": net_id,
		"nickname": nickname,
		"timestamp": timestamp,
		"content": content
	}
	
func to_bytes():
	pass


	
