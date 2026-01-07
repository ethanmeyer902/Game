extends Node2D

@export var first_floor: PackedScene

func _ready() -> void:
	load_floor()

func load_floor() -> void:
	for child in $WorldRoot.get_children():
		child.queue_free()
	@warning_ignore("shadowed_global_identifier")
	var floor = first_floor.instantiate()
	$WorldRoot.add_child(floor)
