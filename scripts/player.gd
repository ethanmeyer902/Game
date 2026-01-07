extends CharacterBody2D

@export var speed: float = 250.0
var facing: Vector2 = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	if input_dir != Vector2.ZERO:
		facing = input_dir

	velocity = input_dir * speed
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		do_attack()

func do_attack() -> void:
	# For now, just print. Later you can spawn a swing or projectile.
	print("Player attack, facing: ", facing)
