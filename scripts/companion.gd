extends Node2D

@export var monster_id: String = "ghost_buddy"
@export var orbit_radius: float = 40.0
@export var orbit_speed: float = 3.0
@export var attack_range: float = 450.0
@export var projectile_scene: PackedScene

@export var max_hp: int = 10
var hp: int

var player: Node2D
var cooldown_left: float = 0.0
var angle: float = 0.0

func _ready() -> void:
	hp = max_hp
	add_to_group("buddies") # makes targeting easy later

func _process(delta: float) -> void:
	if player == null:
		return

	angle += orbit_speed * delta
	global_position = player.global_position + Vector2(cos(angle), sin(angle)) * orbit_radius

	cooldown_left = max(0.0, cooldown_left - delta)
	if cooldown_left == 0.0:
		try_attack()

func take_damage(amount: int) -> void:
	hp -= amount
	print(MonsterDb.get_monster_name(monster_id), " HP:", hp, "/", max_hp)
	if hp <= 0:
		die()

func heal(amount: int) -> void:
	hp = min(max_hp, hp + amount)
	print(MonsterDb.get_monster_name(monster_id), " healed to ", hp, "/", max_hp)

func die() -> void:
	print(MonsterDb.get_monster_name(monster_id), " fainted")
	queue_free()

func try_attack() -> void:
	var target := find_nearest_enemy()
	if target == null:
		return

	var active := MonsterDb.get_active(monster_id)
	cooldown_left = float(active["cooldown"])
	shoot_at(target, int(active["damage"]))

func find_nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var best_dist_sq := attack_range * attack_range

	var enemies := get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if e is Node2D:
			var d_sq := global_position.distance_squared_to(e.global_position)
			if d_sq < best_dist_sq:
				best_dist_sq = d_sq
				nearest = e
	return nearest

func shoot_at(target: Node2D, dmg: int) -> void:
	if projectile_scene == null:
		return

	var p = projectile_scene.instantiate()
	get_tree().current_scene.add_child(p)
	
	p.source = self

	p.global_position = global_position
	var dir := (target.global_position - global_position).normalized()
	p.direction = dir
	p.damage = dmg
