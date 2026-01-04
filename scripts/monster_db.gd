extends Node

# Very small starter database.
# id is the key you store in RunState.
var monsters := {
	"slime_buddy": {
		"name": "Slime Buddy",
		"passive": {"type": "bonus_damage", "value": 1},
		"active": {"type": "spit", "cooldown": 2.5, "damage": 2}
	}
}

func has(id: String) -> bool:
	return monsters.has(id)

func get_monster_name(id: String) -> String:
	return monsters[id]["name"]

func get_passive(id: String) -> Dictionary:
	return monsters[id]["passive"]

func get_active(id: String) -> Dictionary:
	return monsters[id]["active"]
