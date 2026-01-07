extends Node

# saves game state with current floors,
# monsters and party

var current_floor: int = 1
var max_party_size: int = 3

var owned_monsters: Array[String] = []
var selected_party: Array[String] = []

func start_new_run() -> void:
	current_floor = 1
	owned_monsters = ["ghost_buddy"]
	selected_party = ["ghost_buddy"]

func advance_floor() -> void:
	current_floor += 1
