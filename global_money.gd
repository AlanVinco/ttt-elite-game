extends Node

var MONEY = 0

var PLAYER_MONEY = "TOTAL: $ " + str(MONEY)

func win_money():
	MONEY += 100
	PLAYER_MONEY = "TOTAL: $ " + str(MONEY)

func lose_money():
	if MONEY == 0:
		pass
	else:
		MONEY -= 100
	PLAYER_MONEY = "TOTAL: $ " + str(MONEY)
