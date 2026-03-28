extends CharacterBody2D

const RUN_SPEED = 10000.0
const JUMP_STRENGTH = 200.0
const GRAVITY_STRENGTH = 300.0

func _physics_process(delta: float) -> void:
	velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * delta * RUN_SPEED

	if Input.is_action_just_pressed("jump") && is_on_floor() : velocity.y -= JUMP_STRENGTH
	velocity.y += GRAVITY_STRENGTH * delta

	move_and_slide()