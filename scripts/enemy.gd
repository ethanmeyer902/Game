extends CharacterBody2D

@export var max_hp: int = 10
var hp: int

@export var projectile_scene: PackedScene
@export var attack_cooldown: float = 1.5
@export var attack_range: float = 650.0
@export var projectile_damage: int = 2

var cooldown_left: float = 0.0

@onready var hp_label: Label = $HpLabel

func _ready() -> void:
	hp = max_hp
	update_ui()
	add_to_group("enemies")

func _process(delta: float) -> void:
	cooldown_left = max(0.0, cooldown_left - delta)
	if cooldown_left == 0.0:
		try_attack()

func try_attack() -> void:
	var target := find_nearest_buddy_hitbox()
	if target == null:
		return

	cooldown_left = attack_cooldown
	shoot_at(target.global_position)

func find_nearest_buddy_hitbox() -> Area2D:
	var nearest: Area2D = null
	var best_dist_sq := attack_range * attack_range

	var hurtboxes := get_tree().get_nodes_in_group("buddy_hitboxes")
	for h in hurtboxes:
		if h is Area2D:
			var d_sq := global_position.distance_squared_to(h.global_position)
			if d_sq < best_dist_sq:
				best_dist_sq = d_sq
				nearest = h
	return nearest

func shoot_at(target_pos: Vector2) -> void:
	if projectile_scene == null:
		return

	var p = projectile_scene.instantiate()
	get_tree().current_scene.add_child(p)
	
	p.source = self

	p.global_position = global_position
	p.direction = (target_pos - global_position).normalized()
	p.damage = projectile_damage

func take_damage(amount: int) -> void:
	hp -= amount
	update_ui()
	if hp <= 0:
		die()

func update_ui() -> void:
	if hp_label:
		hp_label.text = str(hp)

func die() -> void:
	queue_free()
