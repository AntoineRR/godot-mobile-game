extends Node2D

var money = 0

func add_money(quantity):
	money += quantity

func save() -> Dictionary:
	var save_dict = {
		"money": money
	}
	return save_dict
