class_name Debug extends Node

var enabled:bool = true


# Logging =================================================
func debug_log(message: String, sender: String = "") -> void:
	if not enabled:
		return
	
	var sender_name: String = sender
	if sender == "":
		sender_name = ""
	else:
		sender_name = "[" + sender + "] "
	
	var msg: String = "[LOG] "+ sender_name + message
	print(msg)


func warn(message: String, sender: String = "") -> void:
	if not enabled:
		return
	
	var sender_name: String = sender
	if sender == "":
		sender_name = ""
	else:
		sender_name = "[" + sender + "] "
		
	var msg: String = "[WARN] " + sender_name + message
	push_warning(msg)

func error(message: String, sender: String = "") -> void:
	if not enabled:
		return
	
	var sender_name: String = sender
	if sender == "":
		sender_name = ""
	else:
		sender_name = "[" + sender + "] "
		
	var msg: String = "[ERROR] "+ sender_name + message
	push_error(msg)


func ass(message: String, sender: String = "") -> void:
	if not enabled:
		return
	
	var sender_name: String = sender
	if sender == "":
		sender_name = ""
	else:
		sender_name = "[" + sender + "] "
		
	var msg: String = "[ERROR] "+ sender_name + message
	assert(msg)

# ========================================================
