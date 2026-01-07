extends Area2D

@export var speed: float = 450.0
var direction: Vector2 = Vector2.RIGHT
var damage: int = 1
var lifetime: float = 2.0

var source: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body == source:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	# Ignore other projectiles or any Area2D that is not a hurtbox
	if area.is_in_group("projectiles"):
		return

	var parent := area.get_parent()
	if parent == source:
		return
	if parent and parent.has_method("take_damage"):
		parent.take_damage(damage)
	queue_free()
