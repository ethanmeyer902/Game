extends Node2D

@export var player_scene: PackedScene
@export var companion_scene: PackedScene
@export var enemy_scene: PackedScene

func _ready() -> void:
	if RunState.owned_monsters.is_empty():
		RunState.start_new_run()

	var actors := $Actors

	var player = player_scene.instantiate()
	actors.add_child(player)
	player.global_position = Vector2(400, 250)

	spawn_party(player, actors)
	
	spawn_test_enemy(actors)

func spawn_party(player: Node2D, parent: Node) -> void:
	for id in RunState.selected_party:
		var c = companion_scene.instantiate()
		c.monster_id = id
		c.player = player
		parent.add_child(c)

func spawn_test_enemy(parent: Node) -> void:
	if enemy_scene == null:
		return
	var e = enemy_scene.instantiate()
	parent.add_child(e)
	e.global_position = Vector2(650, 250)
