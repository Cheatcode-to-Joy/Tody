extends CharacterBody2D

class_name PlayerCharacter

@export var state: PlayerState

const RUN_SPEED = 10000.0
const JUMP_STRENGTH = 200.0
const GRAVITY_STRENGTH = 300.0

@export var buffer_timer: Timer
const BUFFER_TIME = 0.3

func _physics_process(delta: float) -> void:
	velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * delta * RUN_SPEED
	velocity.y += GRAVITY_STRENGTH * delta

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if state.vstate == state.vstates.STAND:
			jump()
		else:
			buffer_timer.start(BUFFER_TIME)

func jump() -> void:
	velocity.y -= JUMP_STRENGTH

func _on_state_vstate_changed(vstate: PlayerState.vstates) -> void:
	if vstate == state.vstates.STAND && buffer_timer.time_left > 0:
		jump()