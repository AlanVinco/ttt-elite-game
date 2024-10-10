extends Node

var TIME = 9

var TOTAL_TIME = str(TIME) + ":00"

signal irla_bathroom
signal irla_in_bathroom

var IRLA_ACTION = "IN CLASS"
var JOE_ACTION = "SPY"

func change_time():
	TIME += 2
	TOTAL_TIME = str(TIME) + ":00"
	
	if TIME == 13:
		emit_signal("irla_bathroom")
		IRLA_ACTION = "GO TO BATHROOM"
	
	if TIME >= 19:
		print("HORA DE SALIDA")
	else:
		pass


func change_irla_actions(action):
	IRLA_ACTION = action
	emit_signal("irla_in_bathroom")
