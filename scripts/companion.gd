extends Node2D

@export var monster_id: String = "mush_buddy"
@export var orbit_radius: float = 40.0
@export var orbit_speed: float = 3.0

var player: Node2D
var cooldown_left: float = 0.0
var angle: float = 0.0

func _process(delta: float) -> void:
	if player == null:
		return

	angle += orbit_speed * delta
	global_position = player.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius

	cooldown_left = max(0.0, cooldown_left - delta)
	if cooldown_left == 0.0:
		try_attack()

func try_attack() -> void:
	var active := MonsterDb.get_active(monster_id)
	cooldown_left = float(active["cooldown"])
	# For now, just print. Next step is find nearest enemy and shoot.
	print(MonsterDb.get_monster_name(monster_id), " uses ", active["type"])
